require 'bracket.rb'
require 'player.rb'

class Picks
  def initialize(picks_file, bracket_file)
    bracket = Bracket.new(bracket_file)
    teams = bracket.get_teams()
    matchups = bracket.get_matchups()
    @players = [] 

    File.readlines(picks_file).each do | line |
      player = Player.new(line, teams, matchups)
      @players << player
    end
  end

  def to_json()
    pick_json = @players.map {|pick| pick.to_json}
    "[#{pick_json.join(",")}]"
  end
end

