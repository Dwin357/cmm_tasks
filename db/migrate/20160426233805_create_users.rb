class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email

      t.integer :tasks_count

      t.timestamps null: false
    end
  end
end
