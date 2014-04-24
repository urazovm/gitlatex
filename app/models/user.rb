class User < ActiveRecord::Base
  has_many :projects

  class << self
    def authenticate(login, password)
      result = Gitlab.session login, password
      User.where(id: result.id).first
    end
  end
end
