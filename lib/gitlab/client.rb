module Gitlab
  class Client
    def set_request_defaults(endpoint, private_token, sudo=nil)
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless endpoint
      #raise Error::MissingCredentials.new("Please set a private_token for user") unless private_token
      
      self.class.base_uri endpoint
      self.class.headers 'PRIVATE-TOKEN' => private_token if private_token
      self.class.headers 'SUDO' => sudo if sudo
    end
    
    def session(login, password)
      post("/session", body: {login: login, password: password})
    end

    def gitlatex
      session Settings.gitlab_account.email, Settings.gitlab_account.password
    end
  end
end
