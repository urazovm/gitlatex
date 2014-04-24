module Gitlab
  class Client
    module Users
      def session(login, password)
        post("/session", body: {login: login, password: password})
      end
      
      def gitlatex
        session Settings.gitlab_account.email, Settings.gitlab_account.password
      end
    end
  end
end
