module Breadcrumb
  extend ActiveSupport::Concern

  def add_breadcrumb(name, url=nil)
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url}
  end
  
  module ClassMethods
    def add_breadcrumb(name, url=nil)
      before_filter do
        add_breadcrumb name, url
      end
    end
  end
end
