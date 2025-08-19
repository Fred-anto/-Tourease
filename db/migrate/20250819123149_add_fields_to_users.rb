class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :age, :integer
    add_column :users, :phone_number, :string
  end
end
