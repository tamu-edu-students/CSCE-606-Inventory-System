class CreateBins < ActiveRecord::Migration[8.0]
  def change
    create_table :bins do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :location
      t.string :category_name

      t.timestamps
    end
  end
end
