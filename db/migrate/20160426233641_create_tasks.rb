class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :task_name

      t.timestamps null: false

      ### elaboration on model ###

      t.integer :task_entries_count
    end
  end
end
