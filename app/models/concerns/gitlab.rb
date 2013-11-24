require 'active_support/concern'
module Gitlab
  extend ActiveSupport::Concern
  included do
    include Virtus.model
  end

  module ClassMethods
    def gitlab
      @gitlab ||= Accessor.new
    end
  end

  class Accessor
    include Virtus.model
    include HTTParty
    base_uri "#{Settings.gitlab_host}api/v#{Settings.gitlab_api_version}/"

    attribute :id, Integer
    attribute :name, String
    attribute :private_token, String

    def available?(session)
      attributes = session
      self.private_token.present?
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
      if self.private_token.present?
        {headers: {"PRIVATE-TOKEN" => self.private_token}}
      else
        {}
      end
    end
  end
end
