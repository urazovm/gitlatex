require "#{Rails.root}/lib/gitlatex" 

Rails.application.routes.default_url_options[:host] = "#{Settings.host}:#{Settings.port}"
