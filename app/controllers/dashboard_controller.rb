class DashboardController < AuthenticateController
  def index
    @projects = ProjectDecorator.decorate_collection(Project.all)
    @events = EventsDecorator.decorate(Event.project(@projects.map(&:id))).page(params[:page])
  end
end
