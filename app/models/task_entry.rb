class TaskEntry < ActiveRecord::Base
  belongs_to :task, counter_cache: true
end
