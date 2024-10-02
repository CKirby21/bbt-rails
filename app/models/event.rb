class Event < ApplicationRecord
  has_many :event_scores, dependent: :destroy
  has_many :teams, through: :event_scores

  validates :name, presence: true
end
