class CreateJoinTableTeamsEvents < ActiveRecord::Migration[8.0]
  def change
    create_join_table :teams, :events do |t|
      # t.index [:team_id, :event_id]
      # t.index [:event_id, :team_id]
    end
  end
end
