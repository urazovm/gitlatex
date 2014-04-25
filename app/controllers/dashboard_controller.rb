class DashboardController < AuthenticateController
  def index
    @projects = current_user.authorized_projects.sorted_by_activity.non_archived
    @events = Event.project(@projects.map(&:id)).page(params[:page])
  end
end
