require 'bracket.rb'
require 'player.rb'

class Picks
  def initialize(picks_file, bracket_file)
    teams = get_teams(bracket_file)
    matchups = get_matchups(bracket_file)
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

