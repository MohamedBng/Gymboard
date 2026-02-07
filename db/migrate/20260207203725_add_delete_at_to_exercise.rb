class AddDeleteAtToExercise < ActiveRecord::Migration[8.0]
  def up
    add_column :exercises, :delete_at, :datetime
  end

  def down
    remove_column :exercises, :delete_at
  end
end
