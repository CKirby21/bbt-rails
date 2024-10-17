class ChangeScoreDataTypeInEventScores < ActiveRecord::Migration[8.0]
  def change
    change_column :event_scores, :score, :integer
  end
end
