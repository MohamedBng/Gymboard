class AddPublicToExercises < ActiveRecord::Migration[8.0]
  def up
    add_column :exercises, :public, :boolean, default: false
  end

  def down
    remove_column :exercises, :public
  end
end
