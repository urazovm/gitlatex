class User < ActiveRecord::Base

  class << self
    def authenticate(login, password)
      result = Gitlab.session login, password
    end
  end
end
