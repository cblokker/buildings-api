module AddressFormatters
  extend ActiveSupport::Concern

  def formatted_address
    "#{street_address} #{city}, #{state} #{zip}"
  end
end
