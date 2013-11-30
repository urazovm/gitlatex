class AuthenticateController < ApplicationController
  before_action :authenticated!
end
