class Building < ApplicationRecord
  ### Associations ###
  has_one :address, dependent: :destroy
  belongs_to :client

  accepts_nested_attributes_for :address

  ### Delegates ###
  delegate :name, to: :client, prefix: true
  delegate :formatted_address, to: :address

  ### Validations ###
  validate :validate_custom_fields_against_schema

  def validate_custom_fields_against_schema
    return if custom_fields.blank?

    Jsonb::Validate.new(
      record: self,
      jsonb_schema: custom_fields_schema
    ).call
  end

  def to_api
    {
      id: id,
      address: formatted_address, # Note: would structure this to adhere to db schema. Front end can handle the json as long as we have object integrity throughout API
      client_name: client_name    # Same, ex: client: { id: 3, name: 3 }
    }.merge(self.custom_fields)   # wouldn't flatten - client should know what's custom.
  end

  private

  def custom_fields_schema
    @custom_fields_schema ||= ClientToBuilding::CustomFieldsAdapter
      .new(client.custom_field_attributes).call
  end
end
