class PagesController < ApplicationController
  FIRST_PLACE_POINTS = 6
  PARTICIPATION_POINTS = 1

  def home
    scored_event_map_event_scores = get_scored_event_map_event_scores()
    @year_recent = 0
    scored_event_map_event_scores.each do |scored_event, _|
      if scored_event.date_of_event.year > @year_recent
        @year_recent = scored_event.date_of_event.year
      end
    end
    @leaderboard_recent = get_leaderboard(@year_recent)
  end

  def archive
    @scored_event_map_event_scores = get_scored_event_map_event_scores()
  end

  private

  # :FIXME: Find a better way to do this
  def get_scored_event_map_event_scores
    event_scores = EventScore.all

    scored_events = Set.new
    event_scores.each do |event_score|
      scored_events << Event.find(event_score.event_id)
    end

    scored_event_map_event_scores = {}
    scored_events.each do |scored_event|
      scored_event_map_event_scores[scored_event] = []
      EventScore.where(event_id: scored_event.id).each do |event_score|
        scored_event_map_event_scores[scored_event] << event_score
      end

      # Sort from low to high scores
      sorted = scored_event_map_event_scores[scored_event].sort_by { |event_score| event_score.score }
      scored_event_map_event_scores[scored_event] = sorted
    end

    # Sort from most recent to less recent
    sorted = scored_event_map_event_scores.sort_by { |key, value| key.date_of_event }
    scored_event_map_event_scores = sorted.reverse.to_h

    scored_event_map_event_scores
  end

  def get_leaderboard(year)
    scored_event_map_event_scores = get_scored_event_map_event_scores()
    scored_event_map_event_scores = scored_event_map_event_scores.filter {
      |scored_event, _| scored_event.date_of_event.year == year
    }

    leaderboard = {}
    scored_event_map_event_scores.each do |_, event_scores|
      event_scores.each do |event_score|
        leaderboard[event_score.team] = 0
      end
    end

    scored_event_map_event_scores.each do |_, event_scores|
      place_points = FIRST_PLACE_POINTS
      prev_event_score = nil
      tied_teams = []
      tied_points = 0

      # Assumes event scores have been sorted from best to worst
      event_scores.each do |event_score|
        leaderboard[event_score.team] += PARTICIPATION_POINTS

        if prev_event_score == nil
          leaderboard[event_score.team] += place_points
        elsif event_score.score == prev_event_score.score
          tied_teams << event_score.team
          tied_points += place_points
        else
          # Give points to the previous teams that tied
          if tied_points > 0
            tied_points_fraction = tied_points / tied_teams.length
            tied_teams.each do |tied_team|
              leaderboard[tied_team] += tied_points_fraction
            end
            tied_teams = []
            tied_points = 0
          end

          # Give points to the current team
          leaderboard[event_score.team] += place_points
        end

        place_points -= 1
        prev_event_score = event_score
      end
    end

    leaderboard
  end
end
