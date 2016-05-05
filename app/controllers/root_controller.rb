class RootController < ApplicationController
  skip_before_action :require_login
  
  def index
    if current_user
      redirect_to user_path(current_user)
    else
      redirect_to new_session_path
    end
  end

  def scratch
    @task_entry = TaskEntry.last
    render "shared/scratch"
  end
end