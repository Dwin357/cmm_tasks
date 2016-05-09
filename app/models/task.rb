class Task < ActiveRecord::Base
  belongs_to :project, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :task_entries, dependent: :destroy

  def percent_completed
    percent_of_total(task_entries.select(&:completed?))
  end

  def percent_pending
    percent_of_total(task_entries.select(&:pending?))
  end

  def percent_active
    percent_of_total(task_entries.select(&:active?))
  end

  def percent_of_total(collection)
    (collection.size.to_f / self.task_entries.size * 100).floor
  end
end
