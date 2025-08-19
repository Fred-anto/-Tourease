class CreateTripCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_categories do |t|
      t.references :category, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
