class ProjectsController < ApplicationController
  def new
    @project  = Project.new
    @customer = Customer.find(params[:customer_id])
  end

  def create
    customer = Customer.find(params[:customer_id])
    @project = customer.projects.new(project_params)
    if @project.save
      redirect_to project_path(@project)
    else
      flash[:errors] = @project.errors.full_messages
      render :new
    end
  end

  def destroy
    project = Project.find(params[:id])
    @customer = project.customer
    project.destroy
    redirect_to customer_path(@customer)
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to project_path(@project)
    else
      flash[:errors] = @project.errors.full_messages
      render "edit"
    end
  end

  def show
    @project = Project.includes(:tasks, :customer).find(params[:id])
  end

  private
  def project_params
    params.require(:project).permit(:project_name)
  end
end