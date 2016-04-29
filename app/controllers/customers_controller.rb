class CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to customer_path(@customer)
    else
      flash[:errors] = @customer.errors.full_messages
      render "new"
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to user_path(current_user!)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customer_path(@customer)
    else
      flash[:errors] = @customer.errors.full_messages
      render "edit"
    end    
  end

  def show   
    @customer = Customer.find(params[:id])
  end

  private
  def customer_params
    params.require(:customer).permit(:company, :address, :city, :state, :zip)
  end


end