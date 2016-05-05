FactoryGirl.define do
  factory :task_entry do
    task
    duration 6000 #in seconds
    start_time Time.now
    note "check lower wacker and columbus"
  end

  factory :alt_task_entry, class: TaskEntry do
    task
    duration 1000
    start_time 1.hour.ago
    note "moment to brood"
  end
end
