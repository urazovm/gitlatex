class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :danger

  include ActionView::Helpers::UrlHelper
  include Breadcrumb
  
  add_breadcrumb I18n.t('crumb.dashboard')

  attr_reader :gitlab

  def authenticated!
    redirect_to new_session_path if session[:private_token].nil?
    @gitlab = Session.new session
  end
end
