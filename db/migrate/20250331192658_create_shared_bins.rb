class CreateSharedBins < ActiveRecord::Migration[8.0]
  def change
    create_table :shared_bins do |t|
      t.references :bin, null: false, foreign_key: true
      t.references :shared_with, null: false, foreign_key: true

      t.timestamps
    end
  end
end
