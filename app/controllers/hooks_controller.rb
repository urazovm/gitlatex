class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def hook
    case params[:event_name]
    when "project_create" then
      ProjectWorker.perform_async(params[:project_id])
    when "project_destroy" then
      ProjectDeleteWorker.perform_async(params[:project_id])
    when "user_add_to_team" then
      UserProjectWorker.perform_async(params[:project_id], params[:user_email])
    when "user_remove_from_team" then
      UserProjectDeleteWorker.perform_async(params[:project_id], params[:user_email])
    when "user_create" then
      UserWorker.perform_async(params[:user_id])
    when "user_destroy" then
      UserDeleteWorker.perform_async(params[:user_id])
    else
    end
    head :ok
  end
end
