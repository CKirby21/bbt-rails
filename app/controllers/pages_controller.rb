class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[ home archive gallery ]

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

    # Assumes event scores have been sorted from best to worst
    scored_event_map_event_scores.each do |_, event_scores|
      score_map_teams = {}
      event_scores.each do |event_score|
        if !score_map_teams.key?(event_score.score)
          score_map_teams[event_score.score] = []
        end
        score_map_teams[event_score.score] << event_score.team
      end
      score_map_teams = score_map_teams.sort_by { |score, _| score }.to_h

      place_points = FIRST_PLACE_POINTS
      score_map_teams.each do |score, teams|
        points_pool = 0
        for _ in 1..teams.length
          points_pool += place_points
          place_points -= 1
          place_points = [ place_points, 0 ].max
        end

        teams.each do |team|
          event_point_count = points_pool.fdiv(teams.length)
          leaderboard[team] += event_point_count + PARTICIPATION_POINTS
        end
      end
    end

    leaderboard = leaderboard.sort_by { |_, score| score }.reverse.to_h
    leaderboard
  end
end
