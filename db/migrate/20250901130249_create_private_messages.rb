class CreatePrivateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :private_messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
