class AddModerateAtToExercise < ActiveRecord::Migration[8.0]
  def up
    add_column :exercises, :moderate_at, :datetime
  end

  def down
    remove_column :exercises, :moderate_at
  end
end
