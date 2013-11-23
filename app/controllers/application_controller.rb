class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :danger

  include ActionView::Helpers::UrlHelper
  include Breadcrumb
  
  add_breadcrumb I18n.t('crumb.dashboard')

  attr_reader :gitlab

  def authenticated!
    redirect_to new_session_path unless session[:private_token] or current_page?(new_session_path) or current_page?(session_path)
    @gitlab = Session.new(session)
  end
end
