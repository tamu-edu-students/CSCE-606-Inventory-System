class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.references :bin, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.datetime :created_date
      t.decimal :value

      t.timestamps
    end
  end
end
