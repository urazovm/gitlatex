class GitlabAccessor
  class HTTP
    include HTTParty
    base_uri "#{Settings.gitlab_host}api/v#{Settings.gitlab_api_version}/"
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
    p self.private_token
    self.private_token.present?
  end
  
  def get(path, options=nil)
    options ||= {}
    options.merge! private_token_header
    p path
    p options
    HTTP.get path, options
  end
  def post(path, options=nil)
    options ||= {}
    options.merge! private_token_header
    HTTP.post path, options
  end
  
  private
  def private_token_header
    if self.private_token.nil?
      {}
    else
      {headers: {"PRIVATE-TOKEN" => self.private_token}}
    end
  end
end
