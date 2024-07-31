FactoryBot.define do
  factory :todo_item do
    title { Faker::Lorem.sentence[0..10] }
    description { Faker::Lorem.sentence[0..50] }
    completed { false }
    association :todo_list
  end
end
