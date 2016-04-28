class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new]

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
end