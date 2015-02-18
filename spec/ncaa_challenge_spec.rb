require 'ncaa_challenge'

describe "challenge" do
  let (:bracket) { JSON.parse(File.read("data/test_bracket.json"), {:symbolize_names => true}) }
  let (:details) { pick_stuff("data/picks.csv", "data/test_bracket.json") } 
  let (:player_picks) { details[:player_picks] } 

  it "has all of the players" do
    expect(details[:player_picks].keys).to eq ["Mark", "Alex D", "Mike E", "Molly D", "Kyle", "Kevin M.", "Gene C.", "Ryan J", "Rob T", "Jon P", "George", "Sam"]
  end
end
