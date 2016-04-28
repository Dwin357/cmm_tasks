class SessionsController < ApplicationController
  skip_before_action :require_login
  
  def new
    flash[:data] = {}
  end

  def create
    usr = User.find_by(username: session_params[:username])

    if usr && usr.authentic_password?(session_params[:password])
      login(usr)
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
    params.require(:session).permit(:username, :password)
  end
end