class Project < ActiveRecord::Base
  include Gitlab::Record

  include ProjectActivation

  default_scope { includes(:namespace) }

  belongs_to :creator, foreign_key: "creator_id", class_name: User.name
  belongs_to :group, -> { where(type: Group) }, foreign_key: "namespace_id"
  belongs_to :namespace

  has_many :users_projects
  has_many :users, through: :users_projects

  has_many :hooks, class_name: ProjectHook.name

  has_many :events

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
end
