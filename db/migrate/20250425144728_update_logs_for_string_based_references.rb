class UpdateLogsForStringBasedReferences < ActiveRecord::Migration[8.0]
  def change
    # Add new fields
    add_column :logs, :bin_name, :string
    add_column :logs, :item_name, :string

    # Remove foreign key constraints if they exist
    # Safe even if constraints weren't enforced
    remove_foreign_key :logs, :bins if foreign_key_exists?(:logs, :bins)
    remove_foreign_key :logs, :items if foreign_key_exists?(:logs, :items)

    # Optional: Remove the bin_id and item_id foreign keys if you want complete independence
    # Otherwise you can leave bin_id and item_id as plain integers
    # If you want to keep bin_id and item_id but as plain numbers, no change needed
  end
end
