class LayoutController < ApplicationController
  # before_action :set_left_gutter


  def set_left_gutter
    set_calendar_date
    set_active_tasks
  end

  def set_active_tasks
    # @active_tasks = current_user!.tasks.select(&:active?).limit(5)
    @active_tasks = current_user!.tasks
  end

  def set_calendar_date
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end
end