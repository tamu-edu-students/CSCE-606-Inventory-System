class ChangeItemIdToBeNullableInPictures < ActiveRecord::Migration[6.1]
  def change
    change_column_null :pictures, :item_id, true  # ✅ Allow `item_id` to be NULL
  end
end
