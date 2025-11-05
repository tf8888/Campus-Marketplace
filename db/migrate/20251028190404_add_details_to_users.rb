class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :address, :string
    add_column :users, :contact_number, :string
    add_column :users, :verified, :boolean, default: false
  end
end
