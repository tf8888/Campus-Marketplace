class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.integer :score, null: false
      t.references :rater, null: false, foreign_key: { to_table: :users }
      t.references :ratee, null: false, foreign_key: { to_table: :users }
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end

    add_index :ratings, [ :rater_id, :request_id ], unique: true
  end
end
