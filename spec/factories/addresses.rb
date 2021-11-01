FactoryBot.define do
  factory :address do
    number { Faker::Address.building_number }
    street { Faker::Address.street_name }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
    customer
  end
end
