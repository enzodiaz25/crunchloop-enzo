class Api::TodoItemsController < Api::BaseController
  PER_PAGE = 1000

  before_action :set_todo_item, only: %i[show update destroy]

  def index
    @todo_items = TodoItem
      .page(params[:page])
      .per(PER_PAGE)
      .where(todo_list_id: params[:todo_list_id])
    render status: :ok
  end

  def show
    render status: :ok
  end

  def create
    @todo_list = TodoList.find(params[:todo_list_id])
    @todo_item = @todo_list.todo_items.build(permitted_params)
    if @todo_item.save
      render status: :created
    else
      render_errors @todo_item.errors, :unprocessable_entity
    end
  end

  def update
    if @todo_item.update(permitted_params)
      render status: :ok
    else
      render_errors @todo_item.errors, :unprocessable_entity
    end
  end

  def destroy
    if @todo_item.destroy
      render json: { message: t(".success") }
    else
      render_errors t(".error"), :unprocessable_entity
    end
  end

  def set_todo_item
    @todo_item = TodoItem.find_by!(id: params[:id], todo_list_id: params[:todo_list_id])
  end

  def permitted_params
    params.require(:todo_item).permit(:title, :description, :completed)
  end
end
