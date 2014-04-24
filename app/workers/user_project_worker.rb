class UserProjectWorker
  include Sidekiq::Worker

  def perform(project_id, user_email)
    "Processing user #{user_email}, project #{project_id}".emph.puts_with do
      user = User.where(email: user_email).first
      if user
        user_project = user.user_projects.where(project_id: project_id).first
        user_project = UserProject.new(project_id: project_id, user_id: user.id) if user_project.nil?
        user_project.synced = true
        user_project.save!
      end
    end
  end
end
