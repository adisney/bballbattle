require 'player.rb'
require 'picks.rb'

describe "player" do
  let (:teams) {{
    "Michigan State" => Team.new("Michigan State", 4, "logo"),
    "Louisville" => Team.new("Louisville", 4, "logo"),
    "Oklahoma" => Team.new("Oklahoma", 5, "logo"),
    "Stanford" => Team.new("Stanford", 10, "logo"),
    "Harvard" => Team.new("Harvard", 12, "logo"),
    "Ohio State" => Team.new("Ohio State", 6, "logo"),
    "Kentucky" => Team.new("Kentucky", 8, "logo"),
    "Nebraska" => Team.new("Nebraska", 11, "logo"),
  }}
  let (:matchups) {[
    Game.new(["Michigan State", "other team"], [71, 64], "final"),
    Game.new(["Louisville", "other team"], [71, 64], "final"),
    Game.new(["Oklahoma", "other team"], [64, 71], "final"),
    Game.new(["Stanford", "other team"], [71, 64], "final"),
    Game.new(["Harvard", "other team"], [71, 64], "final"),
    Game.new(["Ohio State", "other team"], [64, 71], "final"),
    Game.new(["Kentucky", "other team"], [71, 64], "final"),
    Game.new(["Nebraska", "other team"], [64, 71], "final")
  ]}
  let (:player) { Player.new("Jon P,Michigan State,Louisville,Oklahoma,Stanford,Harvard,Ohio State,Kentucky, Nebraska", teams, matchups) }
  let (:player_picks) { player.picks }

  it "determines knocked out teams" do
    knocked_out = player_picks.values.select {|pick| pick.knocked_out }
    expect(knocked_out.map {|team| team.name}).to match_array(["Oklahoma", "Ohio State", "Nebraska"])
  end

  it "gets all teams for a player" do
    expect(player_picks.map {|k, pick| pick.name}).to match_array ["Michigan State","Louisville","Oklahoma","Stanford","Harvard","Ohio State","Kentucky","Nebraska"]
  end

  it "adds up the score for teams" do
    expect(player_picks["Michigan State"].points).to eq 3
    expect(player_picks["Stanford"].points).to eq 5
  end

  it "calculates the players score" do
    expect(player.score).to eq 21
  end

  it "can convert player to json" do
    expect(player.to_json).to eq "{\"name\": \"Jon P\", \"picks\": {\"Michigan State\":{\"name\": \"Michigan State\", \"seed\": 4, \"logo\": \"logo\", \"knockedOut\": false},\"Louisville\":{\"name\": \"Louisville\", \"seed\": 4, \"logo\": \"logo\", \"knockedOut\": false},\"Oklahoma\":{\"name\": \"Oklahoma\", \"seed\": 5, \"logo\": \"logo\", \"knockedOut\": true},\"Stanford\":{\"name\": \"Stanford\", \"seed\": 10, \"logo\": \"logo\", \"knockedOut\": false},\"Harvard\":{\"name\": \"Harvard\", \"seed\": 12, \"logo\": \"logo\", \"knockedOut\": false},\"Ohio State\":{\"name\": \"Ohio State\", \"seed\": 6, \"logo\": \"logo\", \"knockedOut\": true},\"Kentucky\":{\"name\": \"Kentucky\", \"seed\": 8, \"logo\": \"logo\", \"knockedOut\": false},\"Nebraska\":{\"name\": \"Nebraska\", \"seed\": 11, \"logo\": \"logo\", \"knockedOut\": true}}, \"score\": 21}"
  end

  it "can parse it's own json" do
    JSON.parse(player.to_json)
  end
end
