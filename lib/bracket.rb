require 'set'
require 'json'

def get_bracket()
  # based on bracket located at http://www.ncaa.com/interactive-bracket/basketball-men/d1
  response = %x[curl -s http://data.ncaa.com/jsonp/gametool/brackets/championships/basketball-men/d1/2013/data.json]
  json = JSON.parse(response[response.index("(")+1..-3], {:symbolize_names => true})
  json[:update_time] = get_current_time
  json
end

def write_bracket
  puts get_current_time
  puts "starting..."
  file = File.open("bracket.json", "w")
  file.write(get_bracket.to_json)
  file.close
  puts "done"
end

def get_team(game, side)
  team = game[side]
  result = {}
  result[:name] = team[:names][:short]
  result[:seed] = team[:isTop] == "T" ? game[:seedTop].to_i : game[:seedBottom].to_i
  result[:logo] = team[:iconURL].split('/')[8]

  result
end

def parse_bracket(bracket_file)
  JSON.parse(File.read(bracket_file), {:symbolize_names => true})[:games]
end

def get_team_details(bracket_file)
  games = parse_bracket(bracket_file)
  teams = {}

  games.each do |game| 
    away = get_team(game, :away)
    teams[away[:name]] = away
    home = get_team(game, :home)
    teams[home[:name]] = home
  end

  teams
end

def get_side_details(game, side)
  side = game[side]
  details = {}

  details[:name] = side[:names][:short]
  details[:score] = side[:score].to_i
  details[:winner] = side[:winner] == "true"

  details
end

def get_matchups(bracket_file)
  games = parse_bracket(bracket_file)
  matchups = {}

  games.each do |game|
    round = game[:round].to_i
    away = get_side_details(game, :away)
    home = get_side_details(game, :home)

    matchups[round] = [] if !matchups.has_key?(round)
    matchups[round] << {:teams => [away, home], :state => game[:gameState]}
  end

  matchups
end
