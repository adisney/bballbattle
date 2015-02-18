require 'bracket.rb'

def pick_stuff(picks_file, bracket_file)
  {:player_picks => analyze_picks(picks_file, bracket_file)}
end

def parse_line(line, teams)
  split = line.split(',').map(&:strip)
  player = split[0]
  pick_names = split[1..split.size()]
  picks = teams.reduce({}) {|memo, (name, team)|
    if pick_names.include? team.name
      memo.merge!({name => team.clone()}) 
    end
    memo
  }

  return player, picks
end

def get_player_picks(line, teams, matchups)
  player, picks = parse_line(line, teams)

  picks.values.each do | pick |
    games_for_picks = matchups.select {|game| game.teams.include? pick.name}
    games_for_picks.each do |matchup|
      team = matchup.teams.find {|team| team == pick.name}
      if matchup.completed
        pick.lost_game if matchup.loser == pick.name
        pick.won_game if matchup.winner == pick.name
      end
    end
  end

  return {player => {:picks => picks}}
end

def analyze_picks(picks_file, bracket_file)
  teams = get_teams(bracket_file)
  player_picks = {}

  File.readlines(picks_file).each do | line |
    player_picks.merge! get_player_picks(line, teams, get_matchups(bracket_file))
  end

  player_picks.each do |player, picks|
    player_picks[player].merge!({:score => picks[:picks].reduce(0) {|sum, (name, pick)| sum + pick.points}})
  end

  player_picks
end
