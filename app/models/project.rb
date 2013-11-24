class Project < ActiveRecord::Base
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

  attribute :hooked, Boolean, default: true

  def decorate
    @decorate ||= ProjectDecorator.decorate(self)
  end

  class << self
    def with(attrs)
      p = self.where(id: attrs['id']).first
      unless p
        p = self.new attrs
        p.hooked = false
      end
      p
    end
    
    def list
      response = gitlab.get("/projects")
      response.map{|h| self.with(h)} if response.success?
    end
    def get(id)
      response = gitlab.get("/projects/#{id}")
      self.with(response.to_hash) if response.success?
    end
  end
  def hooks
    response = get("/projects/#{id}/hooks")
    Hook.new(response.to_hash) if response.success?
  end
  
end
