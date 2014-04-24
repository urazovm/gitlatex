class UserDeleteWorker
  include Sidekiq::Worker

  def perform(id)
    "Processing user #{id}".emph.puts_with do
      user = User.where(id: id).first
      user.destroy! if user
    end
  end
end
