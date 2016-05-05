class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :project_name
      t.integer :customer_id

      t.timestamps null: false

      ### elaboration on model ###

      t.integer :tasks_count      
    end
  end
end
