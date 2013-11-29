class DashboardController < AuthenticateController
  def index
    @projects = ProjectDecorator.decorate_collection(Project.list || [])
    @events = EventDecorator.decorate_collection(Event.project(@projects.map(&:id)))
  end
end
