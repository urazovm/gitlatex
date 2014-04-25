module Breadcrumb
  extend ActiveSupport::Concern
  
  module ClassMethods
    def drop_breadcrumb(name, url=nil)
      before_filter do
        p name
        drop_breadcrumb name, url
      end
    end
  end
end
