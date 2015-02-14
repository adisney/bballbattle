require 'bracket.rb'

def pick_stuff(picks_file, bracket_file)
  {:player_picks => analyze_picks(picks_file, bracket_file)}
end

def analyze_picks(picks_file, bracket_file)
  teams = get_team_details(bracket_file)
  matchups = get_matchups(bracket_file)
  player_picks = {}

  File.readlines(picks_file).each do | line |
    split = line.split(',')
    player = split[0]
    picks = teams(split[1..split.size()], teams)

    picks.each do | pick |
      pick[:knocked_out] = false
      matchups.values.each do |round|
        round.each do |matchup|
          team = matchup[:teams].find {|team| team[:name] == pick[:name]}
          pick[:knocked_out] |= true if matchup[:state] == "final" && team && team[:winner] == false
        end
      end
    end
    player_picks[player] = {:picks => picks}
  end

  player_picks
end

def teams(picks, team_details) 
  player_picks = [] 
  picks.each { |pick| player_picks << team_details[pick.strip()] }

  player_picks
end
