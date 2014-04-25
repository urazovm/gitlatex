class Project < ActiveRecord::Base
  include Gitlab::Record

  belongs_to :creator, foreign_key: "creator_id", class_name: User.name
  belongs_to :group, -> { where(type: Group) }, foreign_key: "namespace_id"
  belongs_to :namespace

  has_many :users_projects
  has_many :users

  has_many :hooks, class_name: ProjectHook.name

  def web_url
    [Settings.gitlab.remote_host, path_with_namespace].join("/")
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
  
  def hooked?
    !!hooks.where(url: Gitlatex::Routes.project_hook_url(id, only_path: false)).first
  end
  alias :hooked :hooked?

  def events
    Event.where(project_id: id)
  end
end
