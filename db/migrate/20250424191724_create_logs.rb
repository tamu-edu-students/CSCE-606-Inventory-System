class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: true, foreign_key: true
      t.references :bin, null: true, foreign_key: true
      t.string :action_type, null: false
      t.datetime :action_date, null: false
      t.string :from_location
      t.string :to_location
      t.text :description

      t.timestamps
    end
    
    add_index :logs, :action_date
    add_index :logs, :action_type
  end
end