class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.boolean :read
      t.references :request, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :messages, :request_id
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
end
