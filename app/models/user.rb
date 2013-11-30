class User
  include Gitlab
  
  attribute :id, Integer
  attribute :username, String
  attribute :email, String
  attribute :name, String
  attribute :state, String
  attribute :created_at, DateTime
  attribute :bio, String
  attribute :skype, String
  attribute :linkein, String
  attribute :twitter, String
  attribute :extern_uid, String
  attribute :provider, String
  attribute :theme_id, Integer
  attribute :color_scheme_id, Integer
  attribute :is_admin, Boolean
  attribute :can_create_group, Boolean
  attribute :can_create_project, Boolean

  def decorate
    @decorate ||= UserDecorator.decorate(self)
  end

  class << self
    def sign_in(params)
      response = gitlab.post("/session", query: params)
      {
        id: response["id"],
        name: response["name"],
        private_token: response["private_token"]
      } if response.success?
    end
    def sign_in?(session)
      gitlab.available? session
    end
    
    def list(options=nil)
      options = (options || {}).select{|key,_| [:page, :per_page].include? key}
      response = gitlab.get("/users", query: options)      
      response.map{|h| User.new(h)} if response.success?
    end
    
    def get(id)
      response = gitlab.get("/users/#{id}")
      User.new(response.to_hash) if response.success?
    end
    
    def current
      response = gitlab.get("/user")
      User.new(response.to_hash) if response.success?
    end
  end
end
