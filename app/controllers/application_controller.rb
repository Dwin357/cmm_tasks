class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper

  before_action :require_login

  private
  def require_login
    if !current_user
      flash[:errors] = ["you must log in first"]
      redirect_to new_session_path
    end
  end
end
