class ProjectsController < AuthenticateController
  drop_breadcrumb I18n.t('crumb.projects'), projects_path
  skip_before_action :verify_authenticity_token, only: [:hook]
  skip_before_action :authenticated!, only: [:hook]
  
  def index
    @projects = current_user.authorized_projects.sorted_by_activity.non_archived
  end

  def show
    @project = Project.where(id: params[:id]).first
    @events = @project.events.page(params[:page])
    drop_breadcrumb @project.name_with_namespace, project_path(@project)
  end

  def update
    @project = Project.where(id: params[:id]).first
    @project.toggle_activate
    if request.xhr?
      respond_to :js
    else
      redirect_to project_path(@project)
    end
  end

  def hook
    @web_hook = WebHook.new params
    @build = @web_hook.build
    if @build.save
      BuildWorker.perform_async @build.id
    end
    head :ok
  end
end
