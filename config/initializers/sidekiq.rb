Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{Settings.redis.host}:#{Settings.redis.port}", namespace: 'gitlatex' }
end
