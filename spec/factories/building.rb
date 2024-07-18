FactoryBot.define do
  factory :building do
    association :client
    custom_fields { {} }

    # Define address association
    after(:build) do |building|
      building.address ||= build(:address, building: building)
    end
  end
end
