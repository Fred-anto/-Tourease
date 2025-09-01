class AddReviewsStatsToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :reviews_count, :integer, null: false, default: 0
    add_column :activities, :rating_avg, :float, null: false, default: 0.0
  end
end
