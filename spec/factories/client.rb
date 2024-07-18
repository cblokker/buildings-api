FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    custom_field_attributes { {} }
  end
end
