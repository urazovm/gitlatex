class User < ActiveRecord::Base
  include Gitlab::Record
  
  has_one :namespace, -> { where type: nil }, foreign_key: :owner_id, class_name: Namespace.name

  has_many :users_groups
  has_many :groups, through: :users_groups
  has_many :owned_groups, -> { where users_groups: { group_access: UsersGroup::OWNER } }, through: :users_groups, source: :group
  
  has_many :groups_projects, through: :groups, source: :projects
  has_many :personal_projects, through: :namespace, source: :projects
  has_many :projects, through: :users_projects
  has_many :created_projects, foreign_key: :creator_id, class_name: Project.name

  has_many :users_projects

  def authorized_groups
    @authorized_groups ||=
      begin
        group_ids = (groups.pluck(:id) + authorized_projects.pluck(:namespace_id))
        Group.where(id: group_ids).order('namespaces.name ASC')
      end
  end

  def authorized_projects
    @authorized_projects ||=
      begin
        project_ids = personal_projects.pluck(:id)
        project_ids += groups_projects.pluck(:id)
        project_ids += projects.pluck(:id).uniq
        Project.where(id: project_ids).joins(:namespace).order('namespaces.name ASC')
      end
  end
  
  class << self
    def authenticate(login, password)
      result = Gitlab.session login, password
      User.where(id: result.id).first
    end
  end
end
