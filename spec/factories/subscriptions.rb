FactoryBot.define do
  factory :subscription do
    title { Faker::Mountain.name }
    price  { Faker::Number.decimal(l_digits: 2) }
    tea
    customer
  end
end
