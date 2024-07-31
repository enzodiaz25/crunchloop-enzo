describe CompleteAllTodoItemsJob do
  let(:todo_list) { FactoryBot.create :todo_list, :with_items, completed_items: false }
  let(:todo_items) { todo_list.todo_items }
  let(:job) { CompleteAllTodoItemsJob.perform_async(todo_list.id) }

  describe "#perform_later" do
    it "enqueues a single job" do
      expect { job }.to change(CompleteAllTodoItemsJob.jobs, :size).by(1)
    end

    it "marks all todo items as completed" do
      expect(todo_items.pluck(:completed)).to all(be false)
      job
      CompleteAllTodoItemsJob.drain
      expect(todo_items.reload.pluck(:completed)).to all(be true)
    end
  end
end
