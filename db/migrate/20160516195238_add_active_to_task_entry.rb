class AddActiveToTaskEntry < ActiveRecord::Migration
  def change
    add_column :task_entries, :active, :boolean, default: false
  end
end
