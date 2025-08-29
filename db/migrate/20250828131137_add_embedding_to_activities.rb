class AddEmbeddingToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :embedding, :vector, limit: 1536
  end
end
