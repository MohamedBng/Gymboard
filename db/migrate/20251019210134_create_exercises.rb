class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end
