class BuildsController < AuthenticateController
  drop_breadcrumb I18n.t('crumb.projects'), projects_path
  
  def show
    @project = Project.get(params[:project_id])
    @build = Build.where(id: params[:id]).first
    drop_breadcrumb @project.name_with_namespace, project_path(@project)
    drop_breadcrumb @build.commit_id, project_build_path(@project, @build)
  end
end
