class TaskEntriesController < LayoutController
  def new
    @task_entry = TaskEntry.new()
    @task = Task.find(params[:task_id])
 
    render partial: "task_entries/new_entry_form", locals:{errors:[], task:@task, task_entry:@task_entry} if request.xhr?

    # if request.xhr?
    #   render :json => { :response => render_to_string("task_entries/_new_entry_form", layout: false, locals:{errors:[], task:@task, task_entry:@task_entry}) }
    # end
  end

  def create
    task         = Task.find(params[:task_id])
    @task_entry  = task.task_entries.new()
    ajax         = request.xhr?
    valid_create = @task_entry.update(task_entry_params)

    if ajax && valid_create
      # render partial: "tasks/nested_task", locals:{task: task}
      render :json => {
        :response => render_to_string(
          "tasks/_nested_task", 
          layout:false, 
          locals:{task: task}
        )
      }

    elsif valid_create #implicitly a non-ajax valid request
      redirect_to task_entry_path(@task_entry)

    elsif ajax #implicitly an ajax non-valid create
      render :json => {
        :response => render_to_string(
          "task_entries/_new_entry_form", 
          layout: false, 
          locals:{ 
            errors: @task_entry.errors.full_messages, 
            task:task, 
            task_entry:@task_entry
          }
        )
      }

    else #implicitely a non-ajax non-valid create
      flash[:errors] = @task_entry.errors.full_messages
      render :new
    end
  end

  def destroy
    task_entry = TaskEntry.find(params[:id])
    @task = task_entry.task
    task_entry.destroy
    
    if request.xhr?
      render nothing: true
    else
      redirect_to task_path(@task)
    end
  end

  def edit
    @task_entry = TaskEntry.find(params[:id])

    render partial: "task_entries/edit_entry_form", locals:{errors:[], task_entry:@task_entry} if request.xhr?
  end

  def update
    @task_entry  = TaskEntry.find(params[:id])
    task         = @task_entry.task
    ajax         = request.xhr?
    valid_update = @task_entry.update(task_entry_params)

    if valid_update && ajax
      # render partial: "tasks/nested_task", locals:{task: task}
      render json: {
        response: render_to_string(
          "tasks/_nested_task", 
          layout: false, 
          locals:{ task:task }
        )
      }

    elsif valid_update #implicitly non-ajax
      redirect_to task_entry_path(@task_entry)

    elsif ajax #implicitly non-valid update
      # render partial: "task_entries/edit_entry_form", locals:{errors:@task_entry.errors.full_messages, task_entry: @task_entry}
      render json: {
        response: render_to_string(
          "task_entries/_edit_entry_form",
          layout: false,
          locals: {
            errors: @task_entry.errors.full_messages,
            task_entry: @task_entry
          }
        )
      }
    else #implicitly non-ajax non-valid update
      flash[:errors] = @task_entry.errors.full_messages
      render :edit
    end
  end

  def show
    @task_entry = TaskEntry.includes(:task).find(params[:id])
  end

  private
  def task_entry_params
    params.require(:task_entry).permit(:note, :s_time, :s_date, :e_time, :e_date)
  end
end