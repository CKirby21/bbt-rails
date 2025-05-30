class EventScore < ApplicationRecord
  belongs_to :team
  belongs_to :event

  validates :score, presence: true, numericality: { greater_than: 0, less_than: 180 }
  validates :team_id, presence: true
  validates :event_id, presence: true
  validates :event_id, uniqueness: { scope: :team_id }
end
