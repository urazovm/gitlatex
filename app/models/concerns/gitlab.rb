require 'active_support/concern'
module Gitlab
  extend ActiveSupport::Concern
  included do
    include Virtus.model
  end

  module ClassMethods
    def gitlab
      GitlabAccessor.instance
    end
  end
end
