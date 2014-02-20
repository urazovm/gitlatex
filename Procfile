web: bundle exec unicorn_rails -p $PORT -E development
worker: bundle exec sidekiq -C config/sidekiq.yml -q default -e development