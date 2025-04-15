class AddDefaultSharingToBins < ActiveRecord::Migration[8.0]
  def change
    add_column :bins, :is_shared, :boolean, default: false, null: false
  end
end
