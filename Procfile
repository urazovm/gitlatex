web: bundle exec rails s Puma -p $PORT
worker: bundle exec sidekiq -C config/sidekiq.yml -q default -e development
