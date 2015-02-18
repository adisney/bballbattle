class Game
  FINAL = "final"

  attr_accessor :teams, :scores, :state

  def initialize(teams, scores, state)
    @teams = teams
    @scores = scores
    @state = state
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

    Game.new([home[:names][:short], away[:names][:short]], 
             [home[:score].to_i, away[:score].to_i], 
             game[:gameState])
  end
end
