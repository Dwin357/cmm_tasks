FactoryGirl.define do
  factory :task_entry do
    task
    duration 600 #I imagine this as in seconds
    note "check lower wacker and columbus"
  end

  factory :alt_task_entry, class: TaskEntry do
    task
    duration 100
    note "moment to brood"
  end
end
