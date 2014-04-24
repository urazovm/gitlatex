require 'sidekiq/web'
require 'gitlatex/admin_constraint'

Gitlatex::Application.routes.draw do
  root "dashboard#index"

  resources :projects, only: [:index, :show, :update] do
    post :hook
    resources :builds, only: [:show]
  end
  
  resource :session, only: [:create, :new, :destroy]

  mount Sidekiq::Web => '/sidekiq', :constraints => Gitlatex::AdminConstraint.new
end
