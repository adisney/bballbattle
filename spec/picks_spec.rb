require 'picks'

describe "picks" do
  let (:picks) { Picks.new("data/picks.csv", "data/test_bracket.json") }
  let (:from_json) { JSON.parse(picks.to_json, :symbolize_names => true) }
  let (:players) { from_json.map {|player| player[:name]} }

  it "should get picks for all players" do
    expect(players).to match_array(["Alex D", "Gene C.", "George", "Jon P", "Kevin M.", "Kyle", "Mark", "Mike E", "Molly D", "Rob T", "Ryan J", "Sam"])
  end

  it "can parse it's own json" do
    JSON.parse(picks.to_json)
  end
end
