require 'json'

require 'team.rb'

describe "team" do
  let (:team) { Team.new('Louisville', 4, 'louisville.70.png') }

  it 'has a name' do
    expect(team.name).to eq 'Louisville'
  end

  it "has a seed" do
    expect(team.seed).to eq 4
  end

  it "has a logo file name" do
    expect(team.logo).to eq 'louisville.70.png'
  end

  it "initializes knocked out to false" do
    expect(team.knocked_out).to be false
  end

  it "can knock a team out" do
    team.lost_game
    expect(team.knocked_out).to be true
  end

  it "initializes points to 0" do
    expect(team.points).to eq 0
  end

  it "updates points per win" do
    team.won_game
    team.won_game
    team.won_game
    expect(team.points).to eq 9
  end

  it "can clone a team" do
    cloned_team = team.clone
    expect(cloned_team.name).to eq(team.name)
    expect(cloned_team.seed).to eq(team.seed)
    expect(cloned_team.logo).to eq(team.logo)
  end
  
  it "converts to json" do
    expect(team.to_json).to eq("{\"name\": \"Louisville\", \"seed\": 4, \"logo\": \"louisville.70.png\", \"knockedOut\": false}")
  end

  it "can parse it's own JSON" do
    JSON.parse(team.to_json)
  end

  describe "from json" do
    let (:json) { 
      JSON.parse("{\"home\": {
        \"score\": \"71\",
        \"names\": {
          \"full\": \"University of Louisville\",
          \"short\": \"Louisville\",
          \"seo\": \"louisville\",
          \"char6\": \"LOUIS\",
          \"char8\": \"\",
          \"char10\": \"\"
        },
        \"description\": \"(29-5)\",
        \"iconURL\": \"/sites/default/files/images/logos/schools/l/louisville.70.png\",
        \"radioUrl\": \"\",
        \"isTop\": \"T\",
        \"winner\": \"true\"
      },
      \"seedTop\": 4,
      \"seedBottom\": 12}", :symbolize_names => true) }
    let (:parsed_team) { Team.from_json(json, :home) }

    it "can create a Team" do
      expect(parsed_team.name).to eq(team.name)
      expect(parsed_team.seed).to eq(team.seed)
      expect(parsed_team.logo).to eq(team.logo)
    end
  end
end
