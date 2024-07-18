module Jsonb
  class Validate
    include ActiveModel::Model

    DEFAULT_JSONB_FIELD = :custom_fields

    def initialize(record:, jsonb_schema:, jsonb_key_name: DEFAULT_JSONB_FIELD)
      @record = record
      @jsonb_schema = jsonb_schema
      @jsonb_key_name = jsonb_key_name
    end

    def call
      begin
        JSON::Validator.validate!(jsonb_schema, record.send(jsonb_key_name))
      rescue JSON::Schema::ValidationError => e
        record.errors.add(jsonb_key_name, e.message)
      end
    end

    private

    attr_accessor :record, :jsonb_schema, :jsonb_key_name
  end
end
