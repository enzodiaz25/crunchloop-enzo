require "rails_helper"

describe Api::TodoItemsController do
  render_views

  describe "GET #index" do
    let(:todo_list) { FactoryBot.create :todo_list, :with_items, items_count: 5 }

    context "on page 1" do
      before do
        get :index, format: :json, params: { page: 1, todo_list_id: todo_list.id }
      end

      it "returns a success code" do
        expect(response.status).to eq(200)
      end

      it "includes todo items" do
        todo_items = JSON.parse(response.body)

        aggregate_failures "includes all necessary fields" do
          todo_item = todo_items.first
          expect(todo_item.keys).to match_array %w[id title description completed todo_list_id]
          expect(todo_item["todo_list_id"]).to eq(todo_list.id)
        end
      end
    end

    context "on page 2" do
      before do
        get :index, format: :json, params: { page: 2, todo_list_id: todo_list.id }
      end

      it "returns a success code" do
        expect(response.status).to eq(200)
      end

      it "responds with no records" do
        todo_items = JSON.parse(response.body)
        expect(todo_items).to be_blank
      end
    end
  end

  describe "GET #show" do
    let(:todo_item) { FactoryBot.create :todo_item }
    let(:valid_params) do
      {
        id: todo_item.id,
        todo_list_id: todo_item.todo_list_id
      }
    end

    context "with valid params" do
      before { get :show, format: :json, params: valid_params }
      
      it "returns a success code" do
        expect(response.status).to eq(200)
      end

      it "returns the todo item" do
        response_item = JSON.parse(response.body)
        aggregate_failures "includes all required fields" do
          expect(todo_item["id"]).to eq(todo_item.id)
          expect(todo_item["title"]).to eq(todo_item.title)
          expect(todo_item["description"]).to eq(todo_item.description)
          expect(todo_item["completed"]).to eq(todo_item.completed)
          expect(todo_item["todo_list_id"]).to eq(todo_item.todo_list_id)
        end
      end
    end

    context "with an invalid item id" do
      it "retuns a 'not found' code" do
        valid_params[:id] = 1000
        get :show, format: :json, params: valid_params
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST #create" do
    let!(:todo_list) { FactoryBot.create :todo_list }
    let(:valid_params) do
      {
        todo_list_id: todo_list.id,
        todo_item: {
          title: Faker::Lorem.sentence[0..10],
          description: Faker::Lorem.sentence[0..50],
          completed: false,
        }
      }
    end

    context "with valid params" do
      before { post :create, format: :json, params: valid_params }

      it "returns a 'created' status code" do
        expect(response.status).to eq(201)
      end

      it "returns the item" do
        item = JSON.parse(response.body)
        attributes = item.with_indifferent_access.slice(*valid_params[:todo_item].keys)
        expect(item["todo_list_id"]).to eq(todo_list.id)
        expect(attributes).to eq(valid_params[:todo_item].stringify_keys)
      end
    end

    context "with invalid params" do
      before do
        valid_params[:todo_item][:title] = nil
        post :create, format: :json, params: valid_params
      end

      it "returns an unprocessable entity status code" do
        expect(response.status).to eq(422)
      end

      it "includes the errors in the response" do
        errors = JSON.parse(response.body).with_indifferent_access
        expect(errors[:errors]).to_not be_empty
      end
    end
  end

  describe "PUT #update" do
    let!(:todo_item) { FactoryBot.create :todo_item }
    let(:valid_params) do
      {
        todo_item: { title: Faker::Lorem.characters(number: 10) },
        id: todo_item.id,
        todo_list_id: todo_item.todo_list.id
      }
    end

    context "with valid_params" do
      before { put :update, format: :json, params: valid_params }

      it "returns a success code" do
        expect(response.status).to eq(200)
      end

      it "returns the item reflecting the changes" do
        response_item = JSON.parse(response.body)
        expect(response_item["todo_list_id"]).to eq(todo_item.todo_list.id)
        expect(response_item["title"]).to eq(valid_params[:todo_item][:title])
      end
    end

    context "with invalid params" do
      before do
        valid_params[:todo_item][:title] = Faker::Lorem.characters(number: 500)
        put :update, format: :json, params: valid_params
      end

      it "returns an unprocessable entity status code" do
        expect(response.status).to eq(422)
      end

      it "includes the errors in the response" do
        errors = JSON.parse(response.body).with_indifferent_access
        expect(errors[:errors]).to_not be_empty
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:todo_item) { FactoryBot.create :todo_item }
    let(:params) do
      {
        id: todo_item.id,
        todo_list_id: todo_item.todo_list.id
      }
    end
    before { delete :destroy, format: :json, params: params }

    it "returns a success code" do
      expect(response.status).to eq(200)
    end

    it "deletes the record" do
      expect(TodoItem.where(id: todo_item.id)).to_not exist
    end
  end
end
