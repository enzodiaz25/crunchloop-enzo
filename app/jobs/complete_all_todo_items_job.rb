class CompleteAllTodoItemsJob
  include Sidekiq::Job

  # For the purpose of this challenge and to demonstrate the progressive completion of items in the UI,
  # we perform an update in the DB and DOM through turbo-stream for each todo-item. 
  # However, we could consider ignoring future callbacks, using `update_all`, 
  # and marking all items as completed in the UI at once.
  # Alternatively, if completing a todo item is an expensive task, we could enqueue a job for each item.
  def perform(todo_list_id)
    todo_items = TodoItem.where(todo_list_id: todo_list_id, completed: false)
    return unless todo_items.exists?
    todo_items.find_each do |todo_item|
      todo_item.update(completed: true)
    end
  end
end
