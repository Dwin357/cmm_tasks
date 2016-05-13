class SessionsController < ApplicationController
  skip_before_action :require_login
  layout "sessions"

  def new
    if remembered?
      login(remembered_user!)
      redirect_to user_path(current_user!)
    end
    flash[:data] = {}
  end

  def create
    usr = User.find_by(username: session_params[:username])

    if usr && usr.authentic_password?(session_params[:password])
      login(usr)
      remember(usr) if session_params[:remember_me]
      redirect_to user_path(usr)
    else
      flash[:data]   = {username: session_params[:username]}
      flash[:errors] = ["invalid username-password combination"]
      render "new"
    end
  end

  def destroy
    logout
    redirect_to new_session_path
  end

  private
  def session_params
    params.require(:session).permit(:username, :password, :remember_me)
  end
end