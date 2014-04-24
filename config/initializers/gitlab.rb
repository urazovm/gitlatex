Gitlab.configure do |config|
  config.endpoint = "http://#{Settings.gitlab.host}/api/v#{Settings.gitlab.api_version}"
  config.user_agent = 'Gitlatex'
end

Gitlab::Client.send :include, Gitlatex::Gitlab
