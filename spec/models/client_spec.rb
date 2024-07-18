require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:client) { build(:client) }

  describe 'Associations' do
    it { should have_many(:buildings).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }

    describe '#validate_custom_field_attributes' do
      context 'when custom_field_attributes is present' do
        before do
          allow(client)
            .to receive(:custom_field_attributes)
            .and_return({ 'test_field' => 'value' })
          allow(client).to receive(:custom_field_attributes_schema)
            .and_return({ 'properties' => { 'test_field' => { 'type' => 'string' } } })
        end

        it 'validates custom_field_attributes against schema' do
          expect(Jsonb::Validate)
            .to receive(:new)
            .with(
              record: client,
              jsonb_schema: { 'properties' => { 'test_field' => { 'type' => 'string' } } },
              jsonb_key_name: :custom_field_attributes
            ).and_call_original

          client.validate_custom_field_attributes
        end
      end

      context 'when custom_field_attributes is blank' do
        before do
          allow(client)
            .to receive(:custom_field_attributes)
            .and_return(nil)
        end

        it 'skips validation' do
          expect(Jsonb::Validate).not_to receive(:new)

          client.validate_custom_field_attributes
        end
      end
    end
  end
end