class AddEventRefToEventScores < ActiveRecord::Migration[8.0]
  def change
    add_reference :event_scores, :event, null: false, foreign_key: true
  end
end
