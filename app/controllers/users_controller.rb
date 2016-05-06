class UsersController < LayoutController
  skip_before_action :require_login, only: [:new, :create]

  def new
    flash[:errors] = nil
    @navbar_off = true
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_path(@user)
    else
      flash[:errors] = @user.errors.full_messages
      @navbar_off = true
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
      @user = user_from_params!
      if @user.update(user_params)
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
    @user = User.includes(:tasks).find(params[:id])
  end

  def destroy
    if valid_destroy?
      @user = user_from_params!
      @user.destroy
      logout
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

  def user_from_params!
    @usr_from_param ||= User.find(params[:id])
  end

  def valid_edit?
    # this can be more complicated if needed
    current_user == user_from_params!
  end

  def valid_destroy?
    # this can be more complicated if needed
    current_user == user_from_params!
  end
end