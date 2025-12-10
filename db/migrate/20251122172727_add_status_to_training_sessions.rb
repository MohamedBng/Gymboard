class AddStatusToTrainingSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :training_sessions, :status, :integer, default: 0, null: false
  end
end
