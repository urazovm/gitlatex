class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_breadcump :root
end
