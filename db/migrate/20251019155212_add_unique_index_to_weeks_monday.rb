class AddUniqueIndexToWeeksMonday < ActiveRecord::Migration[7.0]
  def change
    add_index :weeks, :monday, unique: true
  end
end
