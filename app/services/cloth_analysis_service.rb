# Sends a cloth image to Claude and returns structured lace recommendations.
#
# Usage:
#   result = ClothAnalysisService.call(image_data: base64_string, content_type: "image/jpeg")
#   result.success?  # => true
#   result.payload   # => { dominant_colors: [...], texture_style: "...", ... }
#
# Payload keys (all symbolized):
#   :dominant_colors          — Array of color name strings (1-3)
#   :texture_style            — String describing fabric texture/weave
#   :occasion_tags            — Array of occasion strings
#   :recommended_lace_types   — Array matching Category names in the DB
#   :recommended_lace_keywords — Array of short search keywords
class ClothAnalysisService < ApplicationService
  MODEL      = "claude-opus-4-6-20240229"
  MAX_TOKENS = 1024

  PROMPT = <<~PROMPT.freeze
    You are a textile and lace expert for an Indian fabric store called Avi Lace Studio.
    Analyze this cloth image and return ONLY a valid JSON object with these exact keys:

    {
      "dominant_colors": ["<color name>"],
      "texture_style": "<brief description of fabric texture and weave, e.g. 'sheer chiffon with floral print'>",
      "occasion_tags": ["<one or more of: ethnic, bridal, casual, formal, festive, party>"],
      "recommended_lace_types": ["<one or more of: Cotton Laces, Net Laces, Silk Trims, Embroidered Lace, Border Trims, Ribbon Laces>"],
      "recommended_lace_keywords": ["<2-5 short search terms describing lace styles matching this cloth, e.g. 'golden border', 'floral motif', 'scallop edge'>"]
    }

    Rules:
    - dominant_colors: 1-3 colors using common names (ivory, royal blue, gold, etc.)
    - recommended_lace_types: use ONLY the exact category names listed above
    - recommended_lace_keywords: short terms that will be used to search product names/descriptions
    - Return ONLY the JSON object — no markdown, no code fences, no explanation.
  PROMPT

  def initialize(image_data:, content_type:)
    @image_data   = image_data
    @content_type = content_type
  end

  def call
    client   = build_client
    response = client.messages.create(
      model:      MODEL,
      max_tokens: MAX_TOKENS,
      messages:   [
        {
          role:    "user",
          content: [
            {
              type:   "image",
              source: {
                type:       "base64",
                media_type: @content_type,
                data:       @image_data
              }
            },
            {
              type: "text",
              text: PROMPT
            }
          ]
        }
      ]
    )

    raw_json = response.content.first.text.to_s.strip
    parsed   = JSON.parse(raw_json)
    normalize!(parsed)
    success(parsed.symbolize_keys)
  rescue JSON::ParserError => e
    Rails.logger.error("[ClothAnalysisService] Invalid JSON from Claude: #{e.message}")
    failure("Could not parse AI response. Please try again.")
  rescue Anthropic::Errors::RateLimitError
    failure("AI service is busy right now. Please try again in a moment.")
  rescue Anthropic::Errors::AuthenticationError
    Rails.logger.error("[ClothAnalysisService] Invalid API key")
    failure("AI service configuration error. Please contact support.")
  rescue Anthropic::Errors::APIStatusError => e
    Rails.logger.error("[ClothAnalysisService] API error #{e.class}: #{e.message}")
    failure("Could not analyze the image. Please try again.")
  rescue Anthropic::Errors::APIError => e
    Rails.logger.error("[ClothAnalysisService] API error: #{e.class} — #{e.message}")
    failure("Could not analyze the image. Please try again.")
  rescue StandardError => e
    Rails.logger.error("[ClothAnalysisService] Error: #{e.class} — #{e.message}")
    failure("Could not analyze the image. Please try again.")
  end

  private

  def build_client
    Anthropic::Client.new(api_key: ENV.fetch("ANTHROPIC_API_KEY"))
  end

  def normalize!(parsed)
    parsed["dominant_colors"]            ||= []
    parsed["texture_style"]              ||= ""
    parsed["occasion_tags"]              ||= []
    parsed["recommended_lace_types"]     ||= []
    parsed["recommended_lace_keywords"]  ||= []
  end
end
