class DropSessionsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :sessions do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
