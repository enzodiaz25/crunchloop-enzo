class TodoItem < ApplicationRecord
  belongs_to :todo_list, counter_cache: true

  validates :title, length: {maximum: 150}, presence: true
  validates :description, length: {maximum: 1000}

  after_update_commit { broadcast_replace_to self }
end
