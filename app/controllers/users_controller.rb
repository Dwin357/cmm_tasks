class UsersController < LayoutController
  skip_before_action :require_login, only: [:new, :create]
  layout 'sessions', only: [:new, :create]

  def new
    flash[:errors] = nil
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      remember(@user) if wants_to_be_remembered?
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
  def wants_to_be_remembered?
    params.require(:user).permit(:remember_me)[:remember_me]
  end

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