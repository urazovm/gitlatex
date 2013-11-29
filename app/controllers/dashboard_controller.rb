class DashboardController < AuthenticateController
  def index
    @projects = ProjectDecorator.decorate_collection(Project.list || [])
    @events = Event.project(@projects.map(&:id))
  end
end
