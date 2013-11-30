class BuildsController < AuthenticateController
  add_breadcrumb I18n.t('crumb.projects'), projects_path
  def show
    @project = Project.get(params[:project_id]).decorate
    @build = Build.where(id: params[:id]).first.decorate
    add_breadcrumb @project.name_with_namespace, project_path(@project)
    add_breadcrumb @build.commit_id, project_build_path(@project, @build)
  end
end
