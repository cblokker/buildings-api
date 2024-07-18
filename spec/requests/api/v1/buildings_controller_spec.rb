require 'rails_helper'

RSpec.describe Api::V1::BuildingsController, type: :request do
  let!(:client) do
    create(:client,
      id: 323232,
      name: 'test-name',
      custom_field_attributes: {
        field1: { type: 'freeform' },
        field2: { type: 'freeform' }
      }
    )
  end

  let!(:buildings) do
    create_list(:building, 10, custom_fields: { field1: 'one' }, client: client)
  end

  describe "GET /api/v1/buildings" do
    it "returns a list of buildings" do
      get "/api/v1/buildings", params: { per_page: 5, after: nil }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      expect(body['status']).to eq('success')
      expect(body['buildings'].count).to eq(5)
      body['buildings'].each do |building|
        expect(building).to include(
          "id",
          "address",
          "client_name",
          "field1"
        )
      end
    end
  end

  describe "POST /api/v1/buildings" do
    it "creates a new building" do
      building_params = {
        client_id: 323232,
        building: {
          custom_fields: { field1: 'value1' },
          address_attributes: {
            street_address: '123 Main St',
            city: 'Sample City',
            state: 'CA',
            zip: '12345'
          }
        }
      }

      post "/api/v1/buildings", params: building_params
      expect(response).to have_http_status(:created)

      expect(JSON.parse(response.body)).to eq(
        {
          "status" => "success",
          "building" => {
            "id" => Building.last.id,
            "address" => "123 Main St Sample City, CA 12345",
            "client_name" => "test-name",
            "field1" => "value1"
          }
        }
      )
    end
  end

  describe "PATCH /api/v1/buildings/:id" do
    let!(:client_2) do
      create(:client,
        name: 'test-name-2',
        custom_field_attributes: {
          field_z: { type: :freeform }
        }
      )
    end
    let(:building_2) { create(:building, id: 12345, client: client_2) }

    it "updates an existing building" do
      building_params = {
        client_id: client_2.id,
        building: {
          custom_fields: { field_z: 'value2' },
          address_attributes: {
            id: building_2.address.id,
            street_address: '456 Elm St',
            city: 'Sample City',
            state: 'CA',
            zip: '12345'
          }
        }
      }

      patch "/api/v1/buildings/#{building_2.id}", params: building_params

      expect(response).to have_http_status(:ok)

      expect(JSON.parse(response.body)).to eq(
        {
          "status" => "success",
          "building" => {
            "id" => building_2.id,
            "address" => "456 Elm St Sample City, CA 12345",
            "client_name" => "test-name-2",
            "field_z" => "value2"
          }
        }
      )
    end
  end
end
