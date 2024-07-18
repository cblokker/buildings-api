class Client < ApplicationRecord
  attr_readonly :custom_field_attributes

  ### Associations ###
  has_many :buildings, dependent: :destroy

  ### Validations ###
  validates :name, presence: true
  validate :validate_custom_field_attributes

  SCHEMA_FILE_PATH = Rails.root.join('lib', 'schemas', 'v1', 'client_custom_field_attributes_schema.json')

  def validate_custom_field_attributes
    return if custom_field_attributes.blank?

    Jsonb::Validate.new(
      record: self,
      jsonb_schema: custom_field_attributes_schema,
      jsonb_key_name: :custom_field_attributes
    ).call
  end

  private

  def custom_field_attributes_schema
    @custom_field_attributes_schema ||= JSON.parse(File.read(SCHEMA_FILE_PATH))
  end
end
