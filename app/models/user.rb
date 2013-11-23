class User
  include Gitlab

  attribute :id, Integer
  attribute :username, String
  attribute :emal, String
  attribute :name, String
  attribute :blocked, Boolean
  attribute :created_at, DateTime
  attribute :bio, String
  attribute :skype, String
  attribute :linkein, String
  attribute :twitter, String
  attribute :dark_scheme, Boolean
  attribute :theme_id, Integer
  attribute :is_admin, Boolean
  attribute :can_create_group, Boolean
  attribute :can_create_team, Boolean
  attribute :can_create_project, Boolean

  attribute :private_token, String

  def decorate
    @decorate ||= UserDecorator.decorate(self)
  end
end
