require 'json'
require 'date'
require 'picks.rb'

@bracket = nil

def get_points(seed)
seed_to_points = {
                  1 => 1,
                  2 => 2,
                  3 => 2,
                  4 => 3,
                  5 => 3,
                  6 => 4,
                  7 => 4,
                  8 => 4,
                  9 => 5,
                  10 => 5,
                  11 => 5,
                  12 => 6,
                  13 => 6,
                  14 => 7,
                  15 => 7,
                  16 => 8
                  }
                  seed_to_points[seed]
end

def get_current_time
  (Time.now.utc + Time.zone_offset("-05:00")).strftime("%Y-%m-%d %H:%M:%S")
end

def get_bracket()
  # based on bracket located at http://www.ncaa.com/interactive-bracket/basketball-men/d1
  response = %x[curl -s http://data.ncaa.com/jsonp/gametool/brackets/championships/basketball-men/d1/2013/data.json]
  json = JSON.parse(response[response.index("(")+1..-3], {:symbolize_names => true})
  json[:update_time] = get_current_time
  json
end

def get_totals(picks_file, bracket_file)
  player_picks = pick_stuff("data/picks.csv", "data/test_bracket.json")
end
