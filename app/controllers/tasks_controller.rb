class TasksController < LayoutController
  def new
    @task    = Task.new
    @project = Project.find(params[:project_id])

    render partial: "tasks/new_task_form", locals:{errors:[], project:@project, task: @task} if request.xhr?
  end

  def create
    project      = Project.find(params[:project_id])
    @task        = project.tasks.new(task_params)
    @task.user   = current_user
    ajax         = request.xhr?
    valid_create = @task.save

    if ajax && valid_create
      render json: {
        response: render_to_string(
          "tasks/_nested_task",
          layout: false,
          locals: {task:@task}
        )
      }

    elsif valid_create #implicitly a non-ajax valid request
      redirect_to task_path(@task)

    elsif ajax #implicitly an ajax non-valid create
      render json: {
        response: render_to_string(
          "tasks/_new_task_form",
          layout: false,
          locals: {
            errors: @task.errors.full_messages,
            project: project,
            task: @task
          }
        )
      }

    else #implicitely a non-ajax non-valid create
      flash[:errors] = @task.errors.full_messages
      render :new
    end
  end

  def destroy
    task = Task.find(params[:id])
    @project = task.project
    task.destroy

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
      format.js { render nothing: true }
    end
  end

  def edit
    @task = Task.find(params[:id])

    render partial: "tasks/edit_task_form", locals:{errors:[], task:@task} if request.xhr?
  end

  def update
    @task        = Task.find(params[:id])
    ajax         = request.xhr?
    valid_update = @task.update(task_params)

    if valid_update && ajax
      render :json => {
        response: render_to_string(
          "tasks/_nested_task",
          layout: false,
          locals: {task:@task}
        )
      }

    elsif valid_update #implicitly non-ajax
      redirect_to task_path(@task)

    elsif ajax #implicitly non-valid update
      render :json => {
        response: render_to_string(
          "tasks/_edit_task_form",
          layout: false,
          locals: {
            errors: @task.errors.full_messages,
            task: @task
          }
        )
      }

    else #implicitly non-ajax non-valid update
      flash[:errors] = @task.errors.full_messages
      render :edit
    end
  end

  def show
    @task = Task.includes(:task_entries, :project, :user).find(params[:id])

    render partial: "tasks/nested_task", locals:{task: @task} if request.xhr?
  end

  private
  def task_params
    params.require(:task).permit(:task_name)
  end
end