class AddUserToItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :items, :user, null: true, foreign_key: true

    # Backfill user_id for existing items
    reversible do |dir|
      dir.up do
        Item.reset_column_information
        Item.find_each do |item|
          item.update_columns(user_id: User.first.id, for_sale: false)
        end
      end
    end

    change_column_null :items, :user_id, false
  end
end
