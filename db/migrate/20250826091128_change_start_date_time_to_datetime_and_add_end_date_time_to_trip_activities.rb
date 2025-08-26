class ChangeStartDateTimeToDatetimeAndAddEndDateTimeToTripActivities < ActiveRecord::Migration[7.1]
  def change
    change_column :trip_activities, :start_date_time, :datetime
    add_column :trip_activities, :end_date_time, :datetime
  end
end
