class Project < ActiveRecord::Base
  belongs_to :customer, counter_cache: true
  has_many :tasks, dependent: :destroy

  def active?
    tasks.any?(&:active?)
  end
end
