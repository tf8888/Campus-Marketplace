class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :role

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :name
  end
end
