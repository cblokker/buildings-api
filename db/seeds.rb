# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

client_data = [
  {
    name: 'Client A',
    custom_field_attributes: {
      color: { type: "freeform" },
      number_of_bathrooms: { type: "number" },
      type_of_roof: { type: "enum", "options": ["Flat", "A-frame", "None"] }
    }
  },
  {
    name: 'Client B',
    custom_field_attributes: {
      color: { type: "freeform" },
      number_of_bedrooms: { type: "number" },
      type_of_floor: { type: "enum", options: ["Hardwood", "Rug"] }
    }
  },
  {
    name: 'Client C',
    custom_field_attributes: {}
  },
  {
    name: 'Client D',
    custom_field_attributes: {
      next_to_church: { type: "freeform" }
    }
  },
  {
    name: 'Client E',
    custom_field_attributes: {
      historic_building: { type: "enum", options: ["Yes", "No"] }
    }
  }
]

# Note: Could have gone with 'insert_all' approach, but wanted to make sure we hit the AR validations (something to consider for bulk insert scenarios)
client_data.each do |client_attrs|
  Client.find_or_create_by!(name: client_attrs[:name]) do |client|
    client.custom_field_attributes = client_attrs[:custom_field_attributes]
  end
end


# For Client A
client_a = Client.find_by(name: 'Client A')
[
  { custom_fields: { color: "red", number_of_bathrooms: 2.5, type_of_roof: "Flat" } },
  { custom_fields: { color: "blue", number_of_bathrooms: 3.5, type_of_roof: "A-frame" } },
  { custom_fields: { color: "green" } }
].each do |building_attrs|
  Building.find_or_create_by!(
    client: client_a,
    custom_fields: building_attrs[:custom_fields],
    address: Address.create(
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip: Faker::Address.zip
    )
  )
end

# For Client B
client_b = Client.find_by(name: 'Client B')
[
  { custom_fields: { color: "green", type_of_floor: "Hardwood", number_of_bedrooms: 12 } },
  { custom_fields: { color: "Green", type_of_floor: "Hardwood", number_of_bedrooms: 2 } },
  { custom_fields: { color: "green-blue", type_of_floor: "Rug" } }
].each do |building_attrs|
  Building.find_or_create_by(
    client: client_b,
    custom_fields: building_attrs[:custom_fields],
    address: Address.create(
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip: Faker::Address.zip
    )
  )
end

# For Client D
client_d = Client.find_by(name: 'Client D')
Building.find_or_create_by(
  client: client_d,
  custom_fields: { next_to_church: "Yes" },
  address: Address.create(
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip: Faker::Address.zip
  )
)

a = Building.find_or_create_by(
  client: Client.find_by(name: 'Client D'),
  custom_fields: { next_to_churc: "Yes" },
  address: Address.create(
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip: Faker::Address.zip
  )
)
