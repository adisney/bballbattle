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

  it "returns picks for all players" do
    expect(player_picks.keys).to eq ["Mark", "Alex D", "Mike E", "Molly D", "Kyle", "Kevin M.", "Gene C.", "Ryan J", "Rob T", "Jon P", "George", "Sam"]
  end

  it "determines knocked out teams" do
    knocked_out = player_picks["Jon P"][:picks].select {|pick| pick[:knocked_out] }
    expect(knocked_out.map {|team| team[:name] }).to eq(["Oklahoma", "Ohio State", "Nebraska"])
  end

  it "gets all teams for a player" do
    picks = ["Louisville", "Michigan State" , "Harvard", "Connecticut"]
    
    expect(teams(picks, team_details)).to match_array [louisville, michiganst, harvard, connecticut]
  end
end
