class DashboardController < AuthenticateController
  def index
    @projects = ProjectDecorator.decorate_collection(current_user.authorized_projects)
    @events = EventsDecorator.decorate(Event.project(@projects.map(&:id))).page(params[:page])
  end
end
