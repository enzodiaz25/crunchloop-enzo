Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    resources :todo_lists, path: :todolists do
      resources :todo_items, path: :todoitems
      put :complete_all_items, on: :member
    end
  end

  resources :todo_lists, only: :index, path: :todolists do
    resources :todo_items, only: :index, path: :todoitems
    put :complete_all_items, on: :member
  end
end
