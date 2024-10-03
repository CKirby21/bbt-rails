class EventScoresController < ApplicationController

  def index
    @event_scores = EventScore.all
  end

  def show
    @event_score = EventScore.find(params[:id])
  end

  def new
    @event_score = EventScore.new
  end

  def create
    @event_score = EventScore.new(event_score_params)

    if @event_score.save
      redirect_to event_scores_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event_score = EventScore.find(params[:id])
  end

  def update
    @event_score = EventScore.find(params[:id])

    if @event_score.update(event_score_params)
      redirect_to event_scores_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event_score = EventScore.find(params[:id])
    @event_score.destroy

    redirect_to event_scores_url, status: :see_other
  end

  private
    def event_score_params
      params.require(:event_score).permit(:score, :team_id, :event_id)
    end

end
