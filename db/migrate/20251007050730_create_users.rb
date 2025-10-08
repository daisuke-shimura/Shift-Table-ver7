class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name,  null: false
      t.integer :status,    default: 0, null: false
      t.string :time1
      t.string :time2
      t.string :time3
      t.string :time4
      t.string :time5
      t.string :time6
      t.string :time7
      t.timestamps
    end
  end
end
