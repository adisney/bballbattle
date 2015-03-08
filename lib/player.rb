require 'team.rb'
require 'game.rb'
require 'json'

class Player
  attr_accessor :name, :picks, :score

  def initialize(line, teams, matchups)
    @name, picks = parse_line(line, teams)
    @picks = get_player_picks(picks, matchups)
    @score = calc_player_score(@picks)
  end

  def to_json
    "{\"name\": \"#{@name}\", \"picks\": #{@picks.to_json}, \"score\": #{@score}}"
  end

  private

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

  def get_player_picks(picks, matchups)
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

    picks
  end

  def calc_player_score picks
    picks.reduce(0) {|sum, (name, pick)| sum + pick.points}
  end
end
