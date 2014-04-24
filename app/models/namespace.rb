class Namespace < ActiveRecord::Base
  include Gitlab::Record

  has_many :projects
  belongs_to :owner, class_name: User.name
end
