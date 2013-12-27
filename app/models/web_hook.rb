class WebHook
  include Gitlab

  attribute :before, String
  attribute :after, String
  attribute :ref, String
  attribute :user_id, Integer
  attribute :user_name, String
  attribute :project_id, Integer
  attribute :repository, Repository
  attribute :commits, Array[Commit]
  attribute :total_commits_count, Integer

  def project
    @project ||= Project.get(project_id)
  end
  def user
    @user ||= User.get(user_id)
  end

  def build
    commit = commits.last
    build = Build.new
    build.project_id = self.project_id
    build.ref = self.ref
    build.repository_name = self.repository.name
    build.repository_url = 
      if Settings.hook and Settings.hook.repository then
        self.repository.url.gsub(Settings.hook.repository,Settings.gitlab.host) 
      else
        self.repository.url
      end
    build.repository_description = self.repository.description
    build.repository_homepage = self.repository.homepage
    build.commit_id = commit.id
    build.commit_message = commit.message
    build.commit_timestamp = commit.timestamp
    build.commit_url = commit.url
    build.author_name = commit.author.name
    build.author_email = commit.author.email
    build.status = :wating
    build
  end
end
