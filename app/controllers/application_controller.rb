class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include ActionView::Helpers::UrlHelper
  include Breadcrumb
  
  class << self
    Rails.application.reload_routes!
    include Rails.application.routes.url_helpers
  end

  def authenticated!
    redirect_to new_session_path unless authenticated?
  end
end
