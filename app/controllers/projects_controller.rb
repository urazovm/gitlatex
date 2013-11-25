class ProjectsController < AuthenticateController
  add_breadcrumb I18n.t('crumb.projects'), projects_path
  
  def index
    @projects = ProjectDecorator.decorate_collection(Project.list || [])
  end

  def show
    @project = Project.get(params[:id]).decorate
    add_breadcrumb @project.name_with_namespace, project_path(@project)
  end

  def update
    if params[:hooked] == "true"
      @project = Project.new params.permit(:id, :hooked)
      p @project
#      if @project.save
#      end
    else
      @project = Project.where(params[:id]).first
      @project.destroy if @project
    end
  end
end
