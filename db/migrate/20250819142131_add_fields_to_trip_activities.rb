class AddFieldsToTripActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :trip_activities, :comment, :text
    add_column :trip_activities, :start_date_time, :date
  end
end
