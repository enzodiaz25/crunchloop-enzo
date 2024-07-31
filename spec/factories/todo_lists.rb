FactoryBot.define do
  factory :todo_list do
    name { Faker::Lorem.sentence[0..10] }
  end

  trait :with_items do
    transient do
      items_count { 5 }
    end

    transient do
      completed_items { false }
    end

    after(:create) do |todo_list, evaluator|
      create_list(:todo_item, evaluator.items_count, todo_list_id: todo_list.id, completed: evaluator.completed_items)
    end
  end
end
