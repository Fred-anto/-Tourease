class CreateTripUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
