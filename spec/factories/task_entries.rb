FactoryGirl.define do
  factory :task_entry do
    task
    start_time Time.new(2000, 1, 1, 23, 5).utc
    duration 600
    # end_time Time.new(2006, 11, 23, 6, 13).utc
    note "check lower wacker and columbus"
  end

  factory :alt_task_entry, class: TaskEntry do
    task
    start_time Time.new(2000, 1, 1, 1, 5).utc
    end_time Time.new(2006, 11, 23, 6, 13).utc
    note "moment to brood"
  end
end
