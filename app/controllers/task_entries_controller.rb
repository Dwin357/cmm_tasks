class TaskEntriesController < ApplicationController
  def new
    @task_entry = TaskEntry.new
  end

  def create
    task = Task.find(params[:task_id])
    @task_entry = task.task_entries.new(task_entry_params)
    if @task_entry.save
      redirect_to task_entry_path(@task_entry)
    else
      flash[:errors] = @task_entry.errors.full_messages
      render :new
    end
  end

  def destroy
    task_entry = TaskEntry.find(params[:id])
    @task = task_entry.task
    task_entry.destroy
    redirect_to task_path(@task)
  end

  def edit
    @task_entry = TaskEntry.find(params[:id])
  end

  def update
    @task_entry = TaskEntry.find(params[:id])
    if @task_entry.update(task_entry_params)
      redirect_to task_entry_path(@task_entry)
    else
      flash[:errors] = @task_entry.errors.full_messages
      render :edit
    end
  end

  def show
    @task_entry = TaskEntry.find(params[:id])
  end

  private
  def task_entry_params
    params.require(:task_entry).permit(:note, :duration)
  end
end