class TodoList < ApplicationRecord
  has_many :todo_items

  validates :name, length: {maximum: 150}, presence: true
end
