class CreateTaskEntries < ActiveRecord::Migration
  def change
    create_table :task_entries do |t|
      t.integer :task_id
      t.integer :duration
      t.string :note
      t.datetime :start_time

      t.timestamps null: false
    end
  end
end
