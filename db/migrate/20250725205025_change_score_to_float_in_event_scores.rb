class ChangeScoreToFloatInEventScores < ActiveRecord::Migration[8.0]
  def change
    change_column :event_scores, :score, :float
  end
end
