require 'active_support/concern'
module Gitlab
  extend ActiveSupport::Concern
  included do
    include Virtus.model
  end

  module InstanceMethods
    def host
      Settings.gitlab_host
    end
    
  end
end
