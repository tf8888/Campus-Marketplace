class AddDefaultTrueToAvailableInItems < ActiveRecord::Migration[8.0]
  def change
    change_column_default :items, :available, true
  end
end
