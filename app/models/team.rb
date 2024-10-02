class Team < ApplicationRecord
  has_many :event_scores, dependent: :destroy
  has_many :events, through: :event_scores

  validates :name, presence: true
end
