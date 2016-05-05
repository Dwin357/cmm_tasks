class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email

      t.timestamps null: false

      ### elaboration on model ###
      
      t.integer :tasks_count
    end
  end
end
