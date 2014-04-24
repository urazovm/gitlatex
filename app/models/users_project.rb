class UsersProject < ActiveRecord::Base
  include Gitlab::Record

  belongs_to :user
  belongs_to :project
end
