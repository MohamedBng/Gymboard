class AddUserIdAndVerifiedAtToExercises < ActiveRecord::Migration[8.0]
  def up
    add_reference :exercises, :user, null: true, foreign_key: true, index: true
    add_column :exercises, :verified_at, :datetime
    add_index :exercises, :verified_at
  end

  def down
    remove_reference :exercises, :user
    remove_index :exercises, :verified_at
    remove_column :exercises, :verified_at
  end
end
