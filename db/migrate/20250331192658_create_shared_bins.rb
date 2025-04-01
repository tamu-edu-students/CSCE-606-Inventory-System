class CreateSharedBins < ActiveRecord::Migration[8.0]
  def change
    create_table :shared_bins do |t|
      t.references :bin, null: false, foreign_key: true
      t.references :shared_with, null: false
      t.timestamps
    end

    add_foreign_key :shared_bins, :users, column: :shared_with_id
  end
end
