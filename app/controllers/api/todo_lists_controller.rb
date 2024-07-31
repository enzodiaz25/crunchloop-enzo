class Api::TodoListsController < Api::BaseController
  PER_PAGE = 1000

  before_action :set_todo_list, only: %i[show update destroy complete_all_items]

  def index
    @todo_lists = TodoList
      .page(params[:page])
      .per(PER_PAGE)
      .all
    render status: :ok
  end

  def show
    render status: :ok
  end

  def create
    @todo_list = TodoList.new(permitted_params)
    if @todo_list.save
      render status: :created
    else
      render_errors @todo_list.errors, :unprocessable_entity
    end
  end

  def update
    if @todo_list.update(permitted_params)
      render status: :ok
    else
      render_errors @todo_list.errors, :unprocessable_entity
    end
  end

  def destroy
    if @todo_list.destroy
      render json: { message: t(".success") }
    else
      render_errors t(".error"), :unprocessable_entity
    end
  end

  def complete_all_items
    CompleteAllTodoItemsJob.perform_async(@todo_list.id)
    render json: { message: t("todo_lists.complete_all_items.success") }, status: :accepted
  end

  def set_todo_list
    @todo_list = TodoList.find(params[:id])
  end

  def permitted_params
    params.require(:todo_list).permit(:name)
  end
end
