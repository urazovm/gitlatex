class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include ActionView::Helpers::UrlHelper

  include Breadcrumb
  add_breadcrumb I18n.t('crumb.dashboard')

  def authenticated!
    redirect_to new_session_path unless session[:private_token].nil? or current_page?(new_session_path)
    @gitlab = Session.new(session)
  end
  before_action :authenticated!
  attr_reader :gitlab
end
