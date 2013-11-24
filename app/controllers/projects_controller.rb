class ProjectsController < AuthenticateController
  add_breadcrumb I18n.t('crumb.projects'), projects_path
  
  def index
  end

  def show
    p params[:id]
    @project = Project.get(params[:id]).decorate
    add_breadcrumb @project.name_with_namespace, project_path(@project)
  end

  def update
  end
end
