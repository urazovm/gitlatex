module BreadcrumbHelper
  def render_breadcrumbs(&block)
    content = render partial: 'layouts/breadcrumbs', layout: false
    if block_given?
      capture(content, &block)
    else
      content
    end
  end
end
