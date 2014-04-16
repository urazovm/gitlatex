class SessionsController < ApplicationController
  layout 'entrance'
  
  def new
  end

  def unauthenticated
    redirect_to new_session_path, flash: { error: t('.failed_to_sign_in')}
  end

  def create
    authenticate!
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to new_session_path, notice: t('.sign_out')
  end

  private
  def user_param
    params.require(:user).permit(:login, :password)
  end
end
