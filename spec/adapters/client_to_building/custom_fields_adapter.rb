require 'rails_helper'

RSpec.describe ClientToBuilding::CustomFieldsAdapter do
  describe '#call' do
    let(:client_custom_field_attributes) do
      {
        field1: { type: 'number' },
        field2: { type: 'freeform' },
        field3: { type: 'enum', options: ['option1', 'option2'] }
      }
    end

    subject { described_class.new(client_custom_field_attributes).call }

    it 'transforms client_custom_field_attributes into schema' do
      expected_schema = {
        type: 'object',
        properties: {
          field1: { type: 'number' },
          field2: { type: 'string' },
          field3: { type: 'string', enum: ['option1', 'option2'] }
        },
        additionalProperties: false
      }

      expect(subject).to eq(expected_schema)
    end

    context 'with unknown field type' do
      let(:client_custom_field_attributes) do
        { 'unknown_field' => { 'type' => 'unknown' } }
      end

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end