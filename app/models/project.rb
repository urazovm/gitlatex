class Project < ActiveRecord::Base
  include Gitlab::Record

  default_scope { includes(:namespace) }

  belongs_to :creator, foreign_key: "creator_id", class_name: User.name
  belongs_to :group, -> { where(type: Group) }, foreign_key: "namespace_id"
  belongs_to :namespace

  has_many :users_projects
  has_many :users, through: :users_projects

  has_many :hooks, class_name: ProjectHook.name

  scope :sorted_by_activity, -> { reorder("projects.last_activity_at DESC") }
  scope :non_archived, -> { where(archived: false) }

  def web_url
    ["http:/", Settings.gitlab.remote_host, path_with_namespace].join("/")
  end

  def path_with_namespace
    if namespace
      namespace.path + '/' + path
    else
      path
    end
  end
  
  def name_with_namespace
    @name_with_namespace ||=
      begin
        if namespace
          namespace.human_name + " / " + name
        else
          name
        end
      end
  end

  def owner
    group || namespace.try(:owner)
  end

  def events
    Event.where(project_id: id)
  end

  def activate?
    hook? and manage?
  end

  def toggle_activate
    activate? ? inactivate : activate
  end
  def activate
    hook unless hook?
    manage unless manage?
  end
  def inactivate
    unhook if hook?
    unmanage if manage?
  end

  private
  def hook_url
    Gitlatex::Routes.project_hook_url(self, only_path: false)
  end

  def manager_id
    Gitlatex::Gitlab::Manager.id
  end

  def manager_name
    Settings.gitlab_account.username
  end
  
  def hook?
    hooks.exists?(url: hook_url)
  end
  def manage?
    users.exists?(username: manager_name)
  end
  
  def hook
    Gitlatex::Gitlab::Manager.accessable!
    Gitlab.add_project_hook id, hook_url
  end
  def manage
    Gitlatex::Gitlab::Manager.accessable!
    Gitlab.add_team_member id, manager_id, 20
  end
  def unhook
    Gitlatex::Gitlab::Manager.accessable!
    hooks.where(url: hook_url).each do |hook|
      Gitlab.delete_project_hook id, hook.id
    end
  end
  def unmanage
    Gitlatex::Gitlab::Manager.accessable!
    Gitlab.remove_team_member id, manager_id
  end
end
