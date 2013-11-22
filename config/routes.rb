require 'sidekiq/web'

Gitlatex::Application.routes.draw do
  get "dashboard/index"

  mount Sidekiq::Web, at: "/sidekiq"
end
