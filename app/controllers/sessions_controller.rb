class SessionsController < ApplicationController
  skip_before_action :require_login
  
  def new
  end

  def create
  end

  def destroy
  end

  private
  def session_params
    params.require(:session).permit(:username, :password)
  end
end