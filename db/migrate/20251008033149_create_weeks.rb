class CreateWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :weeks do |t|
      t.date :monday,                           null: false
      t.boolean :is_created,    default: false, null: false
      t.boolean :is_invisible,  default: true,  null: false
      t.timestamps
    end
  end
end
