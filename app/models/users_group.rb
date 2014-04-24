class UsersGroup < ActiveRecord::Base
  include Gitlab::Record

  belongs_to :user
  belongs_to :group
end
