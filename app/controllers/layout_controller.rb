class LayoutController < ApplicationController
  before_action :set_calendar_date

  def set_calendar_date
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end
end