class Group < Namespace
  
  has_many :users_groups
  has_many :users, through: :users_groups

  def human_name
    name
  end
end
