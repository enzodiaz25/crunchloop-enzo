class TodoListsController < ApplicationController
  PER_PAGE = 30

  def index
    @todo_lists = TodoList
      .page(params[:page])
      .per(PER_PAGE)
      .all
    respond_to :html
  end

  def complete_all_items
    todo_list = TodoList.find(params[:id])
    CompleteAllTodoItemsJob.perform_async(todo_list.id)
    flash.now[:success] = t(".success")
    render_flash
  end
end
