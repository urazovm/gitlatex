require 'sidekiq/web'

Gitlatex::Application.routes.draw do
  root "dashboard#index"

  resource :session, only: [:create, :new, :destroy]

  mount Sidekiq::Web, at: "/sidekiq"
end
