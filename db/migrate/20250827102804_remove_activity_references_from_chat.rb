class RemoveActivityReferencesFromChat < ActiveRecord::Migration[7.1]
  def change
    remove_reference :chats, :activities, foreign_key: true, index: false
    remove_column :trip_activities, :comment
  end
end
