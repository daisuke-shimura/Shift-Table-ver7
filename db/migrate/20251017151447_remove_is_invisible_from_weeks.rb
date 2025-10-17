class RemoveIsInvisibleFromWeeks < ActiveRecord::Migration[7.0]
  def change
    remove_column :weeks, :is_invisible, :boolean
  end
end
