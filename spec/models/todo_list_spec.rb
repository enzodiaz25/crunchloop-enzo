require "rails_helper"

describe TodoList do
  subject(:todo_list) { FactoryBot.build :todo_list }

  it "is valid with valid attributes" do
    is_expected.to be_valid
  end

  it "is not valid without a name" do
    todo_list.name = nil
    is_expected.to_not be_valid
  end

  it "is not valid with a name is longer than 150 characters" do
    todo_list.name = Faker::Lorem.characters(number: 151)
    is_expected.to_not be_valid
  end
end
