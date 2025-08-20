class AddNameToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :name, :string
  end
end
