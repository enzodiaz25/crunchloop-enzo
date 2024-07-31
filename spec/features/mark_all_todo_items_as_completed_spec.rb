feature "Mark all todo items as completed" do
  let(:todo_list) do
    FactoryBot.create(
      :todo_list,
      :with_items,
      items_count: 5,
      completed_items: false
    )
  end

  scenario "happy path" do
    visit todo_list_todo_items_path(todo_list)
    items = find_all("[id^='todo_item_']")
    expect(items).to all(have_text(/.*false$/))
    mark_as_completed_button = find_by_id("mark_all_as_completed")
    mark_as_completed_button.click
    items = find_all("[id^='todo_item_']")
    expect(items).to all(have_text(/.*true$/))
  end
end
