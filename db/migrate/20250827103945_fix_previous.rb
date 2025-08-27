class FixPrevious < ActiveRecord::Migration[7.1]
  def change
    remove_reference :chats, :activities, foreign_key: true, index: false
  end
end
