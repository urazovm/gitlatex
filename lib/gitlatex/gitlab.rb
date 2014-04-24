module Gitlatex::Gitlab
  extend ActiveSupport::Concern

  def set_request_defaults(endpoint, private_token, sudo=nil)
    raise Error::MissingCredentials.new("Please set an endpoint to API") unless endpoint

    self.class.base_uri endpoint
    self.class.default_params :private_token => private_token, :sudo => sudo
    self.class.default_params.delete(:sudo) if sudo.nil?
    self.class.default_params.delete(:private_token) if private_token.nil?
  end
  
  def session(login, password)
    post("/session", body: {login: login, password: password})
  end
end

Dir[File.expand_path('../gitlab/*.rb', __FILE__)].each{|f| require f}
