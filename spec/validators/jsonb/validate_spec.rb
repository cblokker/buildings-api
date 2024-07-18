
require 'rails_helper'

RSpec.describe Jsonb::Validate do
  let(:jsonb_schema) do
    {
      "type" => "object",
      "properties" => {
        "field1" => { "type" => "string" },
        "field2" => { "type" => "number" }
      },
      "required" => ["field1"]
    }
  end

  let(:valid_jsonb_data) { { "field1" => 'test' } }
  let(:invalid_jsonb_data) { { "field1" => 123 } }


  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :custom_fields
    end
  end

  describe "#validate" do
    context "with valid JSONB data" do
      it "passes validation" do
        model = model_class.new(custom_fields: valid_jsonb_data)
        validator = described_class.new(record: model, jsonb_schema: jsonb_schema)

        validator.call
        expect(model.errors).to be_empty
      end
    end

    context "with invalid JSONB data" do
      it "fails validation and adds errors" do
        model = model_class.new(custom_fields: invalid_jsonb_data)
        validator = described_class.new(record: model, jsonb_schema: jsonb_schema)

        validator.call
        expect(model.errors).to have_key(:custom_fields)
      end
    end
  end
end
