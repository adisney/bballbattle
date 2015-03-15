require 'json'
require 'bracket.rb'

class Manager
  def initialize(picks_file, bracket_file)
    @picks_file = picks_file
    @players_picks = {}
    @teams = Bracket.new(bracket_file).get_teams
    File.readlines(picks_file).each do |line|
      split = line.split(',').map(&:strip)
      update(split[0], split[1..split.size()].select{|pick| pick != ""})
    end
  end

  def get(player)
    if !@players_picks.has_key?(player)
      @players_picks[player] = []
      save_picks
    end
    @players_picks[player].to_json
  end

  def save_picks
    File::open(@picks_file, "w") do | file |
      @players_picks.each do | player, picks |
        file.puts "#{player},#{strip_seeds(picks).join(",")}"
      end
    end
  end

  def update(player, picks)
    picks = strip_seeds(picks)
    @players_picks[player] = add_seed(picks)
  end

  private

  def strip_seeds(picks)
    picks.map {|pick| pick.gsub(/\d+\. /, "")}
  end

  def add_seed(picks)
    picks.map {| pick | "#{@teams[pick].seed}. #{pick}"}
  end
end
