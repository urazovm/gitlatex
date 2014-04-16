module Gitlatex::Gitlab
  extend ActiveSupport::Concern

  def session(login, password)
    post("/session", body: {login: login, password: password})
  end
end

Gitlab.config.send :include, Gitlatex::Gitlab
