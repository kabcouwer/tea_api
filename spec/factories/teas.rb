FactoryBot.define do
  factory :tea do
    title { Faker::FunnyName.name }
    description  { Faker::Lorem.sentence(word_count: 4) }
    temperature { Faker::Number.between(from: 70, to: 100) }
    brew_time { rand(10) }
  end
end
