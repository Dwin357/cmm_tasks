FactoryGirl.define do
  factory :task do
    task_name "Patrol dark alleys"
    project
    user
  end

  factory :alt_task, class: Task do
    task_name "Visit Com. Gordon"
    project
    user
  end

end
