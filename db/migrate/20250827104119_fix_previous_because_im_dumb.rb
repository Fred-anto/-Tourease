class FixPreviousBecauseImDumb < ActiveRecord::Migration[7.1]
  def change
    remove_column :trip_activities, :comment, :text
  end
end
