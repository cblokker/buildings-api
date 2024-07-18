require 'rails_helper'

RSpec.describe Building, type: :model do
  let(:client) { create(:client) }
  let(:building) { create(:building, client: client) }

  describe 'Associations' do
    it { should have_one(:address).dependent(:destroy) }
    it { should belong_to(:client) }
    it { should accept_nested_attributes_for(:address) }
  end

  describe '#validate_custom_fields_against_schema' do
    context 'when custom_fields is present' do
      let(:custom_fields_schema) do
        {
          type: 'object',
          properties: {
            test_field: { type: 'string' }
          }
        }
      end

      before do
        allow(building)
          .to receive(:custom_fields)
          .and_return({ test_field: 'value' })
        allow(building.client)
          .to receive(:custom_field_attributes)
          .and_return({ test_field: { 'type' => 'freeform' } })
        allow(ClientToBuilding::CustomFieldsAdapter)
          .to receive(:new)
          .and_return(double(call: custom_fields_schema))
      end

      it 'validates custom_fields against schema' do
        expect(Jsonb::Validate)
          .to receive(:new)
          .with(record: building, jsonb_schema: custom_fields_schema)
          .and_call_original
          
        building.validate_custom_fields_against_schema
      end
    end

    context 'when custom_fields is blank' do
      it 'skips validation' do
        allow(building)
          .to receive(:custom_fields)
          .and_return(nil)

        expect(Jsonb::Validate).not_to receive(:new)
        building.validate_custom_fields_against_schema
      end
    end
  end
end