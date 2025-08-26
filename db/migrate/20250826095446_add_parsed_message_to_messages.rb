class AddParsedMessageToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :parsed_content, :jsonb, default: {}, using: 'content::jsonb'
  end
end
