class AddTodoItemsCountToTodoLists < ActiveRecord::Migration[7.0]
  def change
    add_column :todo_lists, :todo_items_count, :integer
  end
end
