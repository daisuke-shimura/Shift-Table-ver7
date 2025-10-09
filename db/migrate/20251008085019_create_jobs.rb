class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :time1,    null: false, default: ""
      t.string :time2,    null: false, default: ""
      t.string :time3,    null: false, default: ""
      t.string :time4,    null: false, default: ""
      t.string :time5,    null: false, default: ""
      t.string :time6,    null: false, default: ""
      t.string :time7,    null: false, default: ""
      t.string :comment,  null: false, default: ""
      t.integer :user_id, null: false
      t.integer :week_id, null: false
      t.timestamps
    end
  end
end
