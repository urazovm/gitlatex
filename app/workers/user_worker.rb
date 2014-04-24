class UserWorker
  include Sidekiq::Worker

  def perform(id)
    "Processing user #{id}".emph.puts_with do
      Gitlatex::Gitlab::Manager.accessable!
      response = Gitlab.user id
      hash = [:id, :username, :email, :name, :state, :bio, :skype, :linkedin, :twitter, :website_url, :extern_uid, :provider, :theme_id, :color_scheme_id, :is_admin, :can_create_group, :can_create_project, :created_at].map{|k| [k, response.send(k)]}.flatten
      hash = Hash[*hash]
      
      user = User.where(id: response.id).first
      user ||= User.new
      user.attributes = hash
      user.save!
    end
  end
end
