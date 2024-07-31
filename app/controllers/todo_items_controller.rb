class TodoItemsController < ApplicationController
  PER_PAGE = 30

  def index
    @todo_items = TodoItem
      .includes(:todo_list)
      .page(params[:page])
      .per(PER_PAGE)
      .where(todo_list_id: params[:todo_list_id])
    respond_to :html
  end
end
