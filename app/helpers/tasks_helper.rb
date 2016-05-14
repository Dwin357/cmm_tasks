module TasksHelper
  def assigned_to(task)
    if task.user
      task.user.username
    else
      "unassigned"
    end
  end
end