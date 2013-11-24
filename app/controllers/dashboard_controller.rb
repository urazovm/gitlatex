class DashboardController < ApplicationController
  before_action :authenticated!
  
  def index
    @projects = ProjectDecorator.decorate_collection(Project.list || [])
  end
end
