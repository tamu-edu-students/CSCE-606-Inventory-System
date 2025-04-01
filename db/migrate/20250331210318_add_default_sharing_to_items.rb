class AddDefaultSharingToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :is_shared, :boolean, default: false, null: false
  end
end
