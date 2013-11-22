require 'sidekiq/web'

Gitlatex::Application.routes.draw do
  mount Sidekiq::Web, at: "/sidekiq"
end
