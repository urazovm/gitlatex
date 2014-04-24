
Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

module Gitlab
  class Client
    def set_request_defaults(endpoint, private_token, sudo=nil)
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless endpoint
      #raise Error::MissingCredentials.new("Please set a private_token for user") unless private_token
      
      self.class.base_uri endpoint
      self.class.headers 'PRIVATE-TOKEN' => private_token if private_token
      self.class.headers 'SUDO' => sudo if sudo
    end

    def validate_with_rel(response)
      result = validate_without_rel(response)
      result.is_a?(Array) ? Gitlab::ResponseArray.new(response) : result
    end
    alias_method_chain :validate, :rel

    include SystemHooks
  end
end
