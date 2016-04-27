class CustomersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end

  def show
  end

  private
  def session_params
    params.require(:customer).permit(:company, :address, :city, :state, :zip)
  end
end