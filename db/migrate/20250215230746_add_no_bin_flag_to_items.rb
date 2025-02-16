class AddNoBinFlagToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :no_bin, :boolean
  end
end
