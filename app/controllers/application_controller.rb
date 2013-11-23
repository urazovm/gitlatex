class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Breadcrumb
  add_breadcrumb I18n.t('crumb.dashboard')
end
