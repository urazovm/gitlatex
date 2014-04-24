class BuildWorker
  include Sidekiq::Worker
  sidekiq_options queue: :build

  def perform(id)
    @build = Build.where(id: id).first
    if @build
      @build.perform
    end
  end
end
