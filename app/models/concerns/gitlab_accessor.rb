class GitlabAccessor
  class HTTP
    include HTTParty
    format :json
    headers 'Content-type' => 'application/json'
    headers 'Accept' => 'application/json'
    base_uri "http://#{Settings.gitlab.host}/api/v#{Settings.gitlab.api_version}/"
    debug_output
  end
  include Virtus.model
  
  attribute :id, Integer
  attribute :name, String
  attribute :private_token, String
  
  class << self
    def instance
      @instance ||= self.new
    end
  end
  
  def available?(session)
    self.id = session[:id]
    self.name = session[:name]
    self.private_token = session[:private_token]
    HTTP.headers 'PRIVATE-TOKEN' => self.private_token if self.private_token.present?
    self.private_token.present?
  end
  
  def get(path, options=nil)
    options ||= {}
    HTTP.get path, options
  end
  def post(path, options=nil)
    options ||= {}
    options[:body] = JSON.dump(options[:body]) if options[:body]
    HTTP.post path, options
  end
  def delete(path, options=nil)
    options ||= {}
    HTTP.delete path, options
  end
end
