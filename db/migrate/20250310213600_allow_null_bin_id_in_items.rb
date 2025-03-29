class AllowNullBinIdInItems < ActiveRecord::Migration[8.0]
  def change
    change_column_null :items, :bin_id, true  # Allow NULL values for bin_id
    remove_foreign_key :items, :bins          # Remove the old foreign key
    add_foreign_key :items, :bins, on_delete: :cascade  # Add a new foreign key with cascade delete
  end
end
