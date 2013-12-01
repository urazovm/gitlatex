class Project
  include Gitlab

  attribute :id, Integer
  attribute :description, String
  attribute :public, Boolean
  attribute :ssh_url_to_repo, String
  attribute :http_url_to_repo, String
  attribute :web_url, String
  attribute :owner, User
  attribute :name, String
  attribute :name_with_namespace, String
  attribute :path, String
  attribute :path_with_namespace, String
  attribute :issues_enabled, Boolean
  attribute :merge_requests_enabled, Boolean
  attribute :wall_enabled, Boolean
  attribute :wiki_enabled, Boolean
  attribute :snippets_enabled, Boolean
  attribute :created_at, DateTime
  attribute :last_activity_at, DateTime
  attribute :namespace, Namespace

  attribute :hooks, Array[Hook], default: :retrive_hooks
  attribute :hook, Hook, writer: :private, default: :own_hook
  attribute :keys, Array[Key], default: :retrive_keys
  attribute :key, Key, writer: :private, default: :own_key

  def decorate
    @decorate ||= ProjectDecorator.decorate(self)
  end

  def hook_url
    Rails.application.routes.url_helpers.project_hook_url(self, host: Settings.host, port: Settings.port, only_path: false)
  end

  def events
    @events ||= Event.project(self.id)
  end

  def builds
    @builds ||= Build.project(self.id)
  end

  def hooked
    !self.hook.nil? and !self.key.nil?
  end
  alias :hooked? :hooked
  def hooked=(value)
    self.hook =
      if value
        h = add_hook
        self.hooks << h if h
        h
      else
        delete_hook unless self.hook.nil?
      end
    self.key = 
      if value
        h = add_key
        self.keys << h if h
        h
      else
        delete_key unless self.key.nil?
      end
  end

  class << self
    def list
      response = gitlab.get("/projects")
      response.map{|h| self.new(h)} if response.success?
    end
    def get(id)
      response = gitlab.get("/projects/#{id}")
      self.new(response.to_hash) if response.success?
    end
  end

  private
  def retrive_hooks
    response = gitlab.get("/projects/#{id}/hooks")
    response.map{|h| Hook.new(h)} if response.success?
  end
  def own_hook
    hooks.find{|hook| hook.url == hook_url} if hooks
  end
  def retrive_keys
    response = gitlab.get("/projects/#{id}/keys")
    response.map{|h| Key.new(h)} if response.success?
  end
  def own_key
    keys.find{|key| key.key == Key.host_key} if keys
  end

  
  def add_hook
    response = gitlab.post("/projects/#{id}/hooks", body: {url: hook_url})
    Hook.new(response.to_hash) if response.success?
  end
  def delete_hook
    response = gitlab.delete("/projects/#{id}/hooks/#{hook.id}")
    self.hook unless response.success?
  end

  def add_key
    response = gitlab.post("/projects/#{id}/keys", body: {title: "Gitlatex", key: Key.host_key})
    Key.new(response.to_hash) if response.success?
  end
  def delete_key
    response = gitlab.delete("/projects/#{id}/keys/#{key.id}")
    self.key unless response.success?
  end
end
