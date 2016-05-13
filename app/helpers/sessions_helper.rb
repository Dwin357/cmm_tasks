module SessionsHelper
  def current_user
    # returns nil if no current user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user!
    # blows up if no current user
    @current_user ||= User.find(session[:user_id])
  end

  def login(user)
   session[:user_id] = user.id 
  end

  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
  end

  def logout
    session.delete(:user_id) if session[:user_id]
    @current_user = nil
  end  

  def remembered?
    cookies.signed[:user_id]
  end

  def remembered_user!
    User.find(cookies.signed[:user_id])
  end

  def forget_me
    cookies.delete :user_id
  end
end