require 'picks'

describe "picks" do
  let (:louisville) { {:name => "Louisville", :seed => 4} }
  let (:michiganst) { {:name => "Michigan State", :seed => 4} }
  let (:harvard) { {:name => "Harvard", :seed => 12} }
  let (:connecticut) { {:name => "Connecticut", :seed => 7} }
  let (:team_details) { {"Louisville" => louisville, 
                         "Michigan State" => michiganst, 
                         "Harvard" => harvard, 
                         "Connecticut" => connecticut} }

  let (:player_picks) { analyze_picks("data/picks.csv", "data/test_bracket.json") }
  let (:jons_picks) { player_picks["Jon P"][:picks] }

  it "returns picks for all players" do
    expect(player_picks.keys).to eq ["Mark", "Alex D", "Mike E", "Molly D", "Kyle", "Kevin M.", "Gene C.", "Ryan J", "Rob T", "Jon P", "George", "Sam"]
  end

  it "determines knocked out teams" do
    knocked_out = jons_picks.values.select {|pick| pick.knocked_out }
    expect(knocked_out.map {|team| team.name}).to match_array(["Oklahoma", "Ohio State", "Nebraska"])
  end

  it "gets all teams for a player" do
    expect(jons_picks.map {|k, pick| pick.name}).to match_array ["Michigan State","Louisville","Oklahoma","Stanford","Harvard","Ohio State","Kentucky","Nebraska"]
  end

  it "adds up the score for teams" do
    expect(jons_picks["Michigan State"].points).to eq 3
    expect(jons_picks["Stanford"].points).to eq 5
  end

  it "calculates the players score" do
    expect(player_picks["Jon P"][:score]).to eq 21
  end
end
