class AddTeamRefToEventScores < ActiveRecord::Migration[8.0]
  def change
    add_reference :event_scores, :team, null: false, foreign_key: true
  end
end
