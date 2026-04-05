# Base class for all service objects.
# Usage:
#   result = MyService.call(args)
#   result.success? # => true / false
#   result.payload  # => returned data
#   result.error    # => error message on failure
class ApplicationService
  Result = Struct.new(:success?, :payload, :error, keyword_init: true) do
    def failure? = !success?
  end

  def self.call(...)
    new(...).call
  end

  private

  def success(payload = nil)
    Result.new(success?: true, payload: payload, error: nil)
  end

  def failure(error)
    Result.new(success?: false, payload: nil, error: error)
  end
end
