require 'sidekiq/web'

Gitlatex::Application.routes.draw do
  root "dashboard#index"

  resources :projects, only: [:index, :show, :update] do
    post :hook
    resources :builds, only: [:show]
  end
  
  resource :session, only: [:create, :new, :destroy]

  mount Sidekiq::Web, at: "/sidekiq"
end
