require 'active_support/concern'
module Gitlab
  extend ActiveSupport::Concern
  included do
    include Virtus.model
    include ActiveModel::Conversion
  end

  def persisted?
    true
  end
  def gitlab
    self.class.gitlab
  end
  module ClassMethods
    def gitlab
      GitlabAccessor.instance
    end
  end
end
