class User < ActiveRecord::Base
  has_many :projects

  class << self
    def authenticate(login, password)
      result = Gitlab.session login, password
    end
  end
end
