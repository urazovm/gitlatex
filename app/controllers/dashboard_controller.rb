class DashboardController < AuthenticateController
  def index
    @projects = ProjectDecorator.decorate_collection(Project.list || [])
  end
end
