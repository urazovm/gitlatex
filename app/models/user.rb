class User
  include Virtus.model
  
  attribute :id, Integer
  attribute :username, String
  attribute :emal, String
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

  module API
    extend ActiveSupport::Concern

    def users(options=nil)
      options = (options || {}).select{|key,_| [:page, :per_page].include? key}
      response = get("/users", query: options)      
      response.to_a if response.success?
    end

    def user(id)
      response = get("/users/#{id}")
      response.to_hash if response.success?
    end

    def current
      response = get("/user")
      response.to_hash if response.success?
    end
  end
end
