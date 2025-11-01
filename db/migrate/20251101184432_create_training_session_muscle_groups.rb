class CreateTrainingSessionMuscleGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :training_session_muscle_groups do |t|
      t.references :training_session, null: false, foreign_key: true
      t.references :muscle_group, null: false, foreign_key: true

      t.timestamps
    end

    add_index :training_session_muscle_groups, [ :training_session_id, :muscle_group_id ],
              unique: true,
              name: 'index_training_session_muscle_groups_unique'
  end
end
