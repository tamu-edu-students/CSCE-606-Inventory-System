class AddMovementsToSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :movements, :text
  end
end
