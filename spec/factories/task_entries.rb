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

    # end_time Time.new(2006, 11, 23, 6, 13).utc
    duration 500
    note "moment to brood"
  end

  factory :form_field_values, class: TaskEntry do
    # task
    # s_time "01:05"
    # s_date "2000-01-01"
    # e_time "13:15"
    # e_date "2006-11-23"
    # note "check the net"

    task
    s_time "01:05"
    s_date "2000-01-01"
    duration 720
    note "check the net"    
  end
end
