class SessionsController < ApplicationController
  layout 'entrance'
  
  def new
  end

  def create
    if Session.sign_in(user_param, session)
      redirect_to root_path
    else
      redirect_to new_session_path, danger: t('.failed_to_sign_in')
    end
  end

  def destroy
    session[:id] = session[:name] = session[:private_token] = nil
    redirect_to new_session_path, success: t('.sign_out')
  end

  private
  def user_param
    params.require(:user).permit(:login, :password)
  end
end
