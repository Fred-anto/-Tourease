class AddAddressAndDescriptionToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :address, :string
    add_column :activities, :description, :text
  end
end
