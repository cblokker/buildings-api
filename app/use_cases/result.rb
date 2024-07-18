class Result
  attr_reader :value, :error

  def initialize(value, error = nil)
    @value = value
    @error = error
  end

  def success?
    @error.nil?
  end

  def self.success(value)
    new(value)
  end

  def self.failure(error_message)
    Rails.logger.error(error_message) # Maybe choose another adapter for error logs
    new(nil, error_message)
  end
end
