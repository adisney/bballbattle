require 'ncaa_challenge'
require 'json'

describe "challenge" do
  let (:bracket) { JSON.parse(File.read("data/test_bracket.json"), {:symbolize_names => true}) }
  let (:details) { pick_details(bracket) } 
  let (:player_picks) { details[:player_picks] } 

  it "has all of the players" do
    expect(details[:player_picks].keys).to eq ["Mark", "Alex D", "Mike E", "Molly D", "Kyle", "Kevin M.  ", "Gene C. ", "Ryan J ", "Rob T", "Jon P", "George ", "Sam"]
  end

  it "correctly determines player picks" do
    expect(player_picks["Alex D"][:picks].keys).to eq (["Louisville", "Michigan State", "Harvard", "UCLA", "Connecticut", "Kentucky", "Pittsburgh", "Ohio State"])
  end

  it "sums player score" do
    expect(player_picks["Alex D"][:total]).to eq 28
  end

  describe "team details" do
    let (:pick_info) { player_picks["Alex D"][:picks] }

    it "gets team seed" do
      expect(pick_info["Louisville"][:seed]).to eq "4"
    end

    it "gets local logo url" do
      expect(pick_info["Louisville"][:logo_url]).to eq "img/louisville.70.png" 
    end

    it "determines if team is knocked out" do
      expect(pick_info["Louisville"][:knocked_out]).to eq false 
      expect(pick_info["Ohio State"][:knocked_out]).to eq true 
    end
  end
end
