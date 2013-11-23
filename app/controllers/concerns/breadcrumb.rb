require 'active_support/concern'

module Breadcrumb
  extend ActiveSupport::Concern

  included do
    class_attribute :breadcrumbs, instance_reader: false, instance_writer: false
    before_filter do
      @breadcrumbs = self.class.breadcrumbs
    end
  end

  module InstanceMethods
    def add_breadcrumb(name, url=nil)
      @breadcrumbs ||= []
      @breadcrumbs << {name: name, url: url}
    end
  end

  module ClassMethods
    def add_breadcrumb(name, url=nil)
      self.breadcrumbs ||= []
      self.breadcrumbs << {name: name, url: url}
    end
  end
end
