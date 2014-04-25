module BootstrapHelper
  module Breadcrumb
    module Helpers
      def render_breadcrumb
        return "" if @breadcrumbs.size <= 0
        prefix = "".html_safe
        crumb = "".html_safe
        
        @breadcrumbs.each_with_index do |c, i|
          breadcrumb_class = []
          breadcrumb_class << "first" if i == 0
          breadcrumb_class << "last active" if i == (@breadcrumbs.length - 1)
          
          breadcrumb_content = c 
          
          crumb += content_tag(:li, breadcrumb_content ,:class => breadcrumb_class ) + "\n"
        end
        return prefix + content_tag(:ul, crumb, :class => "breadcrumb menu clearfix")
      end
    end
  end
end

ActionController::Base.send :include, BootstrapHelper::Breadcrumb
