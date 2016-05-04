class Project < ActiveRecord::Base
  belongs_to :customer, counter_cache: true
  has_many :tasks, dependent: :destroy
end
