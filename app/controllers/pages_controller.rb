class PagesController < ApplicationController

  def home
    @event_scores = EventScore.all

    scored_events = Set.new
    @event_scores.each do |event_score|
      scored_events << Event.find(event_score.event_id)
    end

    @scored_event_map_event_scores = {}
    scored_events.each do |scored_event|
      @scored_event_map_event_scores[scored_event] = []
      EventScore.where(event_id: scored_event.id).each do |event_score|
        @scored_event_map_event_scores[scored_event] << event_score
      end

      # Sort from low to high scores
      sorted = @scored_event_map_event_scores[scored_event].sort_by { |event_score| event_score.score }
      @scored_event_map_event_scores[scored_event] = sorted
    end

    # Sort from most recent to less recent
    sorted = @scored_event_map_event_scores.sort_by { |key, value| key.date_of_event }
    @scored_event_map_event_scores = sorted.reverse.to_h
  end
end
