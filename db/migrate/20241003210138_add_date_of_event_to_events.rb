class AddDateOfEventToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :date_of_event, :date
  end
end
