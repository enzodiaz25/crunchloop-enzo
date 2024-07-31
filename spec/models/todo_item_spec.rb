require "rails_helper"

describe TodoItem do
  subject(:todo_item) { FactoryBot.build :todo_item }

  it "is valid with valid attributes" do
    is_expected.to be_valid
  end

  it "is not valid without a title" do
    todo_item.title = nil
    is_expected.to_not be_valid
  end

  it "is not valid with a title that is longer than 150 characters" do
    todo_item.title = Faker::Lorem.characters(number: 151)
    is_expected.to_not be_valid
  end

  it "is not valid without a todo list" do
    todo_item.todo_list = nil
    is_expected.to_not be_valid
  end

  it "is not valid with a description that is longer than 1000 characters" do
    todo_item.title = Faker::Lorem.characters(number: 1001)
    is_expected.to_not be_valid
  end

  context "on update" do
    let (:todo_item) { FactoryBot.create :todo_item }

    it "broadcast item changes" do
      expect { todo_item.update(completed: true) }.to have_broadcasted_to(todo_item.to_gid_param)
    end
  end
end
