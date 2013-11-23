module NavbarHelper
  def navbar(options={}, &block)
    content_tag :nav, class: navbar_style(options), role: 'navigation' do
      yield if block_given?
    end
  end
  def navbar_header(&block)
    content_tag :dvi, class: "navbar-header" do
      build = []
      build << content_tag(:button, type: 'button', class: 'navbar-toggle', data: {toggle: 'collapse', target: '#navbar-collapse'}) do
        raw('<span class= "icon-bar"></span>' * 3)
      end
      build << capture(&block) if block_given?
      build.join("").html_safe
    end
  end
  def navbar_collapse(&block)
    content_tag :div, class: 'collapse navbar-collapse', id: 'navbar-collapse' do
      yield if block_given?
    end
  end
  def navbar_brand(name=nil, options=nil, html_options=nil, &block)
    html_options, options, name = options, name, block if block_given?
    html_options ||= {}
    html_options[:class] = "navbar-brand #{html_options[:class]}"
    if block_given?
      link_to name, options, html_options
    else
      link_to name, options, html_options, &block
    end
  end
  def navbar_list(options={}, &block)
    content_tag :ul, class: navbar_list_style(options) do
      yield if block_given?
    end
  end
  def navbar_link(name=nil, options=nil, html_options=nil, &block)
    content_tag :li, class: uri_state(block_given? ? name : options) do
      link_to name, options, html_options, &block
    end
  end

  def uri_state(options=nil)
    url_string = URI.parser.unescape(url_for(options || {})).force_encoding(Encoding::BINARY)
    request_uri = url_string.index("?") ? request.fullpath : request.path
    request_uri = URI.parser.unescape(request_uri).force_encoding(Encoding::BINARY)
    child =
      if url_string =~ /^\w+:\/\//
        "#{request.protocol}#{request.host_with_port}#{request_uri}".start_with?(url_string)
      else
        url_string != "/" and request_uri.start_with?(url_string)
      end
    child ? :active : :inactive
  end 

  private
  def navbar_style(options={})
    r = "navbar navbar-#{options[:inverse] ? "inverse" : "default"}"
    r += " navbar-#{options[:align]}" if options[:align]
    r
  end
  def navbar_list_style(options={})
    r = "nav navbar-nav"
    r += " navbar-" + options[:align] if options[:align]    
    r
  end
end
