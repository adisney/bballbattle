require 'set'
require 'json'
require 'team.rb'
require 'game.rb'

class Bracket
  def initialize(bracket_file)
    @games = parse_bracket(bracket_file)
  end

  def self.get_bracket()
    # based on bracket located at http://www.ncaa.com/interactive-bracket/basketball-men/d1
    response = %x[curl -s http://data.ncaa.com/carmen/brackets/championships/basketball-men/d1/2017/data.json]
    json = JSON.parse(response, {:symbolize_names => true})
    #json[:update_time] = get_current_time
    json
  end

  def self.write_bracket(bracket_file)
    #puts get_current_time
    puts "starting..."
    file = File.open(bracket_file, "w")
    file.write(get_bracket.to_json)
    file.close
    puts "done"
  end

  def get_teams()
    teams = {}

    @games.each do |game| 
      away = Team.from_json(game, :away)
      teams[away.name] = away
      home = Team.from_json(game, :home)
      teams[home.name] = home
    end

    teams.select do |name, team|
      team.seed > 0
    end
  end

  def get_matchups()
    matchups = []

    @games.each do |json|
      game = Game.from_json(json)
      matchups << game if game.round > 1
    end

    matchups
  end

  private

  def parse_bracket(bracket_file)
    JSON.parse(File.read(bracket_file), {:symbolize_names => true})[:games]
  end
end
