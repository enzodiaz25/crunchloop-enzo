require 'rails_helper'

describe Api::TodoListsController do
  render_views

  describe 'GET index' do
    let!(:todo_list) { FactoryBot.create :todo_list }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      context "on page 1" do
        before { get :index, format: :json }

        it 'returns a success code' do
          expect(response.status).to eq(200)
        end
  
        it 'includes todo list records' do
          todo_lists = JSON.parse(response.body)
  
          aggregate_failures 'includes the id and name' do
            expect(todo_lists.count).to eq(1)
            expect(todo_lists[0].keys).to match_array(['id', 'name'])
            expect(todo_lists[0]['id']).to eq(todo_list.id)
            expect(todo_lists[0]['name']).to eq(todo_list.name)
          end
        end
      end

      context "on page 2" do
        before do
          get :index, format: :json, params: { page: 2 }
        end

        it "returns a success code" do
          expect(response.status).to eq(200)
        end
  
        it "responds with no records" do
          todo_lists = JSON.parse(response.body)
          expect(todo_lists).to be_blank
        end
      end
    end
  end

  describe "GET #show" do
    let(:todo_list) { FactoryBot.create :todo_list }
    let(:valid_params) do
      { id: todo_list.id }
    end

    context "with valid params" do
      before { get :show, format: :json, params: valid_params }
      
      it "returns a success code" do
        expect(response.status).to eq(200)
      end

      it "returns the todo list" do
        response_list = JSON.parse(response.body)
        aggregate_failures "includes all required fields" do
          expect(todo_list["id"]).to eq(todo_list.id)
          expect(todo_list["name"]).to eq(todo_list.name)
        end
      end
    end

    context "with an invalid list id" do
      it "retuns a 'not found' code" do
        valid_params[:id] = 1000
        get :show, format: :json, params: valid_params
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      { todo_list: { name: Faker::Lorem.sentence[0..10] } }
    end

    context "with valid params" do
      before { post :create, format: :json, params: valid_params }

      it "returns a 'created' status code" do
        expect(response.status).to eq(201)
      end

      it "returns the todo list" do
        todo_list = JSON.parse(response.body)
        attributes = todo_list.with_indifferent_access.slice(*valid_params[:todo_list].keys)
        expect(attributes).to eq(valid_params[:todo_list].stringify_keys)
      end
    end

    context "with invalid params" do
      before do
        valid_params[:todo_list][:name] = nil
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
    let!(:todo_list) { FactoryBot.create :todo_list }
    let(:valid_params) do
      {
        id: todo_list.id,
        todo_list: { name: Faker::Lorem.characters(number: 10) },
      }
    end

    context "with valid_params" do
      before { put :update, format: :json, params: valid_params }

      it "returns a success code" do
        expect(response.status).to eq(200)
      end

      it "returns the todo list reflecting the changes" do
        response_list = JSON.parse(response.body)
        expect(response_list["id"]).to eq(todo_list.id)
        expect(response_list["name"]).to eq(valid_params[:todo_list][:name])
      end
    end

    context "with invalid params" do
      before do
        valid_params[:todo_list][:name] = Faker::Lorem.characters(number: 500)
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
    let!(:todo_list) { FactoryBot.create :todo_list }
    let(:params) do
      { id: todo_list.id }
    end
    before { delete :destroy, format: :json, params: params }

    it "returns a success code" do
      expect(response.status).to eq(200)
    end

    it "deletes the record" do
      expect(TodoList.where(id: todo_list.id)).to_not exist
    end
  end

  describe "PUT #complete_all_items" do
    let(:todo_list) { FactoryBot.create :todo_list, :with_items }
    let(:params) do
      { id: todo_list.id }
    end

    before do
      put :complete_all_items, format: :json, params: params
    end

    it "returns an 'accepted' status code" do
      expect(response.status).to eq(202)
    end

    it "enqueues a job to mark all todo items as completed" do
      expect(CompleteAllTodoItemsJob.jobs.size).to eq(1)
    end
  end
end
