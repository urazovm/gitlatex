require 'active_support/concern'
module Gitlab
  extend ActiveSupport::Concern
  included do
    include Virtus.model

    include HTTParty
    base_uri base
  end

  module ClassMethods
    def base
      "#{Settings.gitlab_host}api/v#{Settings.gitlab_api_version}/"
    end
  end

  def get(path, options=nil)
    options ||= {}
    options.merge! private_token_header
    self.class.get path, options
  end
  def post(path, options=nil)
    options ||= {}
    options.merge! private_token_header
    self.class.post path, options
  end
  
  private
  def private_token_header
    if self.respond_to?(:private_token) and self.private_token.present?
      {headers: {"PRIVATE-TOKEN" => self.private_token}}
    else
      {}
    end
  end
end
