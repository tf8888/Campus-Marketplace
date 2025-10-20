class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.string :condition
      t.boolean :available
      t.boolean :for_lend
      t.boolean :for_sale
      t.string :location
      t.string :image_url
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :items, :title
  end
end
