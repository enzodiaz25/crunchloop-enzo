todo_list = TodoList.create(name: 'Setup Rails Application')
TodoList.create(name: 'Setup Docker PG database')
TodoList.create(name: 'Create todo_lists table')
TodoList.create(name: 'Create TodoList model')
TodoList.create(name: 'Create TodoList controller')

50.times do |number|
  TodoItem.create(
    todo_list: todo_list,
    title: "Item #{number}",
    description: "Item description #{number}",
    completed: false
  )
end
