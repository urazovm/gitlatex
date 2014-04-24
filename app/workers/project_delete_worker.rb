class ProjectDeleteWorker
  include Sidekiq::Worker

  def perform(id)
    "Processing project #{id}".emph.puts_with do
      project = Project.where(id: id).first
      project.destroy! if project
    end
  end
end
