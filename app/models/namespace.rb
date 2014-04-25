class Namespace < ActiveRecord::Base
  include Gitlab::Record

  has_many :projects
  belongs_to :owner, class_name: User.name

  delegate :name, to: :owner, allow_nil: true, prefix: true

  def human_name
    owner_name
  end
end
