class ProjectWorker
  include Sidekiq::Worker

  def perform(id)
    "Processing project #{id}".emph.puts_with do
      Gitlatex::Gitlab::Manager.accessable!
      response = Gitlab.project id
      hash = [:id, :description, :default_branch, :public, :visibility_level, :ssh_url_to_repo, :http_url_to_repo, :web_url, :name, :name_with_namespace, :path, :path_with_namespace, :issues_enabled, :merge_requests_enabled, :wall_enabled, :wiki_enabled, :snippets_enabled, :created_at, :last_activity_at].map{|k| [k, response.send(k)]}.flatten
      hash = Hash[*hash]
      hash[:owner_id] = response.owner.id if response.owner
      if response.namespace
        hash[:namespace_id] = response.namespace.id
        hash[:namespace_name] = response.namespace.name
        hash[:namespace_path] = response.namespace.path
      end
      project = Project.where(id: response.id).first
      project ||= Project.new
      project.attributes = hash
      project.save!
    end
  end
end
