class Address < ApplicationRecord
  include AddressFormatters

  # Associations
  belongs_to :building

  # Validations
  # Note: Can also add external validations like google maps api (consider usage limits & request times)
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true # NOTE: can add regex validation here
end
