require 'sidekiq/web'

Gitlatex::Application.routes.draw do

  resource :session, only: [:create, :new]

  mount Sidekiq::Web, at: "/sidekiq"
end
