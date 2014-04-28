module ProjectActivation
  extend ActiveSupport::Concern

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

  private
  def hook?
    hooks.exists?(url: hook_url)
  end
  def manage?
    users.exists?(id: manager_id)
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
