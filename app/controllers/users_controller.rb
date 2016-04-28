class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_path(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render "new"
    end
  end

  def edit
    if valid_edit?
      @user = current_user!
      render "edit"
    else
      flash[:errors] = ["invalid edit permission"]
      @user = current_user!
      render "show"
    end
  end

  def update
    if valid_edit?
      @user = current_user!.assign_attributes(user_params)
      if @user.save
        redirect_to user_path(@user)
      else
        flash[:errors] = @user.errors.full_messages
        render "edit"
      end
    else
      flash[:errors] = ["invalid edit permission"]
      @user = current_user!
      render "show"
    end
  end

  def show

  end

  def destroy
    if valid_destroy?
      @user = user_from_params
      @user.destroy
      logout(@user)
      redirect_to root_path
    else
      flash[:errors] = ["invalid destroy permission"]
      render "show"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end

  def valid_edit?
    # this can be more complicated if needed
    current_user
  end

  def valid_destroy?
    # this can be more complicated if needed
    current_user
  end
end