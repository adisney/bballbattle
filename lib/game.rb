class Game
  FINAL = "final"

  attr_accessor :teams, :round, :scores

  def initialize(teams, scores, state, round)
    @teams = teams
    @scores = scores
    @state = state
    @round = round
  end

  def winner
    @scores[0] > @scores[1] ? @teams[0] : @teams[1]
  end

  def loser
    @scores[0] < @scores[1] ? @teams[0] : @teams[1]
  end

  def completed
    @state == FINAL
  end

  def self.from_json(game)
    home = game[:home]
    away = game[:away]

    Game.new([home[:names][:short].rstrip, away[:names][:short].rstrip], 
             [home[:score].to_i, away[:score].to_i], 
             game[:gameState], game[:round].to_i)
  end
end
