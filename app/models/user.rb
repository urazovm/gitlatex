class User < ActiveRecord::Base
  has_many :owned_projects, foreign_key: :owner_id, class_name: Project.name
  has_many :user_projects, dependent: :delete_all
  has_many :projects, through: :user_projects

  class << self
    def authenticate(login, password)
      result = Gitlab.session login, password
      User.where(id: result.id).first
    end
  end
end
