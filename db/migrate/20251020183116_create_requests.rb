class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.text :message

      t.timestamps
    end
    add_index :requests, :item_id
    add_index :requests, :user_id
    add_index :requests, [ :item_id, :user_id ], unique: true
  end
end
