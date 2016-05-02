class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    project = Project.find(params[:project_id])
    @task   = project.tasks.new(task_params)
    if @task.save
      redirect_to task_path(@task)
    else
      flash[:errors] = @task.errors.full_messages
      render :new
    end
  end

  def destroy
    task = Task.find(params[:id])
    @project = task.project
    task.destroy
    redirect_to project_path(@project)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task)
    else
      flash[:errors] = @task.errors.full_messages
      render :edit
    end
  end

  def show
    @task = Task.includes(:task_entries).find(params[:id])
  end

  private
  def task_params
    params.require(:task).permit(:task_name)
  end
end