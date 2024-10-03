class AddUniqueIndexToEventScores < ActiveRecord::Migration[8.0]
  def change
    add_index :event_scores, [:event_id, :team_id], unique: true
  end
end
