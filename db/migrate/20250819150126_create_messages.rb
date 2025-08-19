class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :role
      t.text :content
      t.references :trip, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :activities, null: false, foreign_key: true

      t.timestamps
    end
  end
end
