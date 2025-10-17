class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.boolean :is_visible, default: true, null: false

      t.timestamps
    end
  end
end
