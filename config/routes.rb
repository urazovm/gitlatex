require 'sidekiq/web'

Gitlatex::Application.routes.draw do
  root "dashboard#index"

  mount Sidekiq::Web, at: "/sidekiq"
end
