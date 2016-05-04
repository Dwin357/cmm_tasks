class Task < ActiveRecord::Base
  belongs_to :project, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :task_entries, dependent: :destroy
end
