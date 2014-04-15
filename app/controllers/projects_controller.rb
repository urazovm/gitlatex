class ProjectsController < AuthenticateController
  drop_breadcrumb I18n.t('crumb.projects'), projects_path
  skip_before_action :verify_authenticity_token, only: [:hook]
  skip_before_action :authenticated!, only: [:hook]
  
  def index
    @projects = ProjectDecorator.decorate_collection(Project.list || [])
  end

  def show
    @project = Project.get(params[:id]).decorate
    @events = @project.events.page(params[:page])
    drop_breadcrumb @project.name_with_namespace, project_path(@project)
  end

  def update
    @project = Project.get(params[:id]).decorate
    @project.object.hooked = !@project.object.hooked
    unless request.xhr?
      redirect_to project_path(@project)
    else
      respond_to do |format|
        format.js
      end
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
