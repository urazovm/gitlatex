class Project < ActiveRecord::Base
  include Gitlab::Record

  belongs_to :creator, foreign_key: "creator_id", class_name: User.name
  belongs_to :namespace

  has_many :users_projects
  has_many :users

  has_many :hooks, class_name: ProjectHook.name

  def hooked?
    !!hooks.where(url: Gitlatex::Routes.project_hook_url(id, only_path: false)).first
  end
  alias :hooked :hooked?
end
