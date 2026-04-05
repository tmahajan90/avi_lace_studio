# Sends a cloth image to Google Gemini 1.5 Flash (free tier) and returns
# structured lace recommendations.
#
# Usage:
#   result = ClothAnalysisService.call(image_data: base64_string, content_type: "image/jpeg")
#   result.success?  # => true
#   result.payload   # => { dominant_colors: [...], texture_style: "...", ... }
#
# Payload keys (all symbolized):
#   :dominant_colors            — Array of color name strings (1-3)
#   :texture_style              — String describing fabric texture/weave
#   :occasion_tags              — Array of occasion strings
#   :recommended_lace_types     — Array matching Category names in the DB
#   :recommended_lace_keywords  — Array of short search keywords
#
# Free tier limits: 1,500 requests/day, 15 requests/minute.
# Requires GEMINI_API_KEY in environment.
class ClothAnalysisService < ApplicationService
  include HTTParty

  MODEL   = "gemini-2.5-flash"
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/#{MODEL}:generateContent"

  PROMPT = <<~PROMPT.freeze
    You are a textile and accessories expert for an Indian fabric store called Avi Lace Studio.
    Analyze this cloth image and return ONLY a valid JSON object with these exact keys:

    {
      "dominant_colors": ["<color name>"],
      "texture_style": "<brief description of fabric texture and weave, e.g. 'sheer chiffon with floral print'>",
      "occasion_tags": ["<one or more of: ethnic, bridal, casual, formal, festive, party>"],
      "recommended_lace_types": ["<one or more of: Cotton Laces, Net Laces, Silk Trims, Embroidered Lace, Border Trims, Ribbon Laces, Beaded Laces, Chain Laces, Guipure Laces, Metal Laces, Tassel Laces, Sequins Laces, Animal Brooches, Badge Brooches, Bird Brooches, Chain Brooches, Collar Brooches, Diamond Brooches, Enamel Brooches, Ethnic Wear Brooches, Flower Brooches, Insect Brooches, Metal Brooches, Pearl Brooches, Vintage Brooches, Metal Buttons, Wooden Buttons, Pearl Buttons, Engraved Buttons, Designer Buttons, Jeans Buttons, Beaded Neck Designs, Cord Neck Designs, Embroidery Neck Designs, Handmade Neck Designs, Metal Neck Designs, Tassel Neck Designs, Crochet Neck Designs, Coat Toggles, Frog Closures, PU Leather Toggles, Wooden Toggle Buttons, YKK Zippers, Metal Zippers, Nylon Coil Zippers, Invisible Zippers, Waterproof Zippers, Designer Zippers>"],
      "recommended_lace_keywords": ["<2-5 short search terms describing accessories matching this cloth, e.g. 'golden border', 'floral brooch', 'metal neck design', 'scallop edge'>"]
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
    response = self.class.post(
      API_URL,
      query:   { key: ENV.fetch("GEMINI_API_KEY") },
      headers: { "Content-Type" => "application/json" },
      body:    build_request_body.to_json,
      timeout: 30
    )

    handle_response(response)
  rescue HTTParty::Error, Timeout::Error => e
    Rails.logger.error("[ClothAnalysisService] HTTP error: #{e.class} — #{e.message}")
    failure("AI service timed out. Please try again.")
  rescue StandardError => e
    Rails.logger.error("[ClothAnalysisService] Error: #{e.class} — #{e.message}\n#{e.backtrace.first(5).join("\n")}")
    failure("Could not analyze the image. Please try again.")
  end

  private

  def build_request_body
    {
      contents: [
        {
          parts: [
            {
              inline_data: {
                mime_type: @content_type,
                data:      @image_data
              }
            },
            {
              text: PROMPT
            }
          ]
        }
      ],
      generationConfig: {
        temperature:     0.1,
        maxOutputTokens: 4096
      }
    }
  end

  def handle_response(response)
    body = response.parsed_response

    unless response.success?
      error_message = body.dig("error", "message") || "Unknown error"
      Rails.logger.error("[ClothAnalysisService] Gemini API error #{response.code}: #{error_message}")

      case response.code
      when 429
        return failure("AI service is busy right now. Please try again in a moment.")
      when 401, 403
        Rails.logger.error("[ClothAnalysisService] Invalid or missing GEMINI_API_KEY")
        return failure("AI service configuration error. Please contact support.")
      else
        return failure("Could not analyze the image. Please try again.")
      end
    end

    raw_json = body.dig("candidates", 0, "content", "parts", 0, "text").to_s.strip
    Rails.logger.info("[ClothAnalysisService] Raw Gemini response: #{raw_json[0..300]}")
    raw_json = raw_json.gsub(/\A```(?:json)?\s*/i, "").gsub(/\s*```\z/, "").strip
    parsed   = JSON.parse(raw_json)
    normalize!(parsed)
    success(parsed.symbolize_keys)
  rescue JSON::ParserError => e
    Rails.logger.error("[ClothAnalysisService] Invalid JSON from Gemini: #{e.message} | raw: #{raw_json[0..300]}")
    failure("Could not parse AI response. Please try again.")
  end

  def normalize!(parsed)
    parsed["dominant_colors"]           ||= []
    parsed["texture_style"]             ||= ""
    parsed["occasion_tags"]             ||= []
    parsed["recommended_lace_types"]    ||= []
    parsed["recommended_lace_keywords"] ||= []
  end
end
