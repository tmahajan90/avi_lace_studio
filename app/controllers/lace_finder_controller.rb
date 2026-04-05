class LaceFinderController < ApplicationController
  ALLOWED_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  MAX_SIZE      = 5.megabytes

  def show
  end

  def create
    file = params[:cloth_image]

    error = validate_upload(file)
    if error
      flash.now[:alert] = error
      render :show, status: :unprocessable_entity and return
    end

    analysis_result = ClothAnalysisService.call(
      image_data:   Base64.strict_encode64(file.read),
      content_type: file.content_type
    )

    unless analysis_result.success?
      flash.now[:alert] = analysis_result.error
      render :show, status: :unprocessable_entity and return
    end

    match_result = LaceMatchService.call(analysis: analysis_result.payload)

    unless match_result.success?
      flash.now[:alert] = match_result.error
      render :show, status: :unprocessable_entity and return
    end

    @analysis      = analysis_result.payload
    @products      = match_result.payload[:products]
    @match_summary = match_result.payload[:summary]
    render :results
  end

  private

  def validate_upload(file)
    return "Please select an image to upload."                          if file.blank?
    return "File must be an image (JPEG, PNG, WebP or GIF)."           unless ALLOWED_TYPES.include?(file.content_type)
    return "Image must be smaller than 5 MB."                          if file.size > MAX_SIZE
    nil
  end
end
