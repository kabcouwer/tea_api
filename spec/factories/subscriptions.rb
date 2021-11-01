FactoryBot.define do
  factory :subscription do
    title { Faker::Mountain.name }
    price  { Faker::Number.decimal(l_digits: 2) }
    # traits_for_enum(:status, ["active", "cancelled"])
    # traits_for_enum(:frequency, ["bimonthly", "monthly", "quarterly"])
    tea
    customer
  end
end
