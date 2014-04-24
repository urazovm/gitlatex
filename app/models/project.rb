class Project < ActiveRecord::Base
  belongs_to :owner, foreign_key: :owner_id, class_name: User.name
  has_many :events

  def namespace
    hash = {id: namespace_id, name: namespace_name, path: namespace_path}
    Gitlab::ObjectifiedHash.new(hash)
  end

  def hooked? ; false ; end
  def hooked ; false ; end
end
