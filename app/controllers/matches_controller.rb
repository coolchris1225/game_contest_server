class MatchesController < ApplicationController
  def index
    @contest = Contest.find(params[:contest_id])
    @matches = @contest.matches
  end
  
  def show
    @match = Match.find(params[:id])
  end
end
