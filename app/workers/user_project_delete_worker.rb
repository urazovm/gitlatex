class UserProjectDeleteWorker
  include Sidekiq::Worker

  def perform(project_id, user_email)
    "Processing user #{user_email}, project #{project_id}".emph.puts_with do
      user = User.where(email: user_email).first
      if user
        user_project = user.user_projects.where(project_id: project_id).first
        user_project.destroy! if user_project
      end
    end
  end
end
