module Gitlatex
  class Routes
    class << self
      include ActionView::Helpers
      include ActionDispatch::Routing
      include Rails.application.routes.url_helpers
    end
  end
end
