class BuildWorker
  include Sidekiq::Worker

  def perform(id)
    @build = Build.where(id: id).first
    if @build
      @build.perform
    end
  end
end
