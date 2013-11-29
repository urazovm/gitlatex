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
end
