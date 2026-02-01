class AddUsedCountToExercise < ActiveRecord::Migration[8.0]
  def up
    add_column :exercises, :used_count, :integer, default: 0
  end

  def down
    remove_column :exercises, :used_count
  end
end
