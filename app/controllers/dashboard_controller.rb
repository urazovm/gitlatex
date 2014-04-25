class DashboardController < AuthenticateController
  def index
    @projects = current_user.authorized_projects
    @events = Event.project(@projects.map(&:id)).page(params[:page])
  end
end
