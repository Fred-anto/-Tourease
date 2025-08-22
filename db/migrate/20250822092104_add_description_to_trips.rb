class AddDescriptionToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :description, :text
  end
end
