class CreateEventScores < ActiveRecord::Migration[8.0]
  def change
    create_table :event_scores do |t|
      t.float :score

      t.timestamps
    end
  end
end
