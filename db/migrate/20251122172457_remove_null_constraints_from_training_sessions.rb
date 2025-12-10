class RemoveNullConstraintsFromTrainingSessions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :training_sessions, :name, true
    change_column_null :training_sessions, :start_time, true
    change_column_null :training_sessions, :end_time, true
    change_column_null :training_sessions, :user_id, true
  end
end
