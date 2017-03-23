require 'game.rb'
require 'json'

describe "game" do
  let (:game) { Game.new(["Louisville", "Manhattan"], [71, 64], Game::FINAL, 2) }

  it "has two teams" do
    expect(game.teams).to eq ["Louisville", "Manhattan"]
  end

  it "has a score" do
    expect(game.scores).to eq [71, 64]
  end

  it "has a winner" do
    expect(game.winner).to eq "Louisville"
  end

  it "has a loser" do
    expect(game.loser).to eq "Manhattan"
  end

  it "knows when game complete" do
    expect(game.completed).to eq true
  end

  it "has the game round" do
    expect(game.round).to eq 2
  end

  describe "from json" do
    let (:json) { 
      JSON.parse("{\"home\": {
        \"score\": \"71\",
        \"names\": {
          \"full\": \"University of Louisville\",
          \"short\": \"Louisville \",
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
      \"seedBottom\": 12,
      \"round\": \"2\",
      \"gameState\": \"final\",
      \"away\": {
        \"score\": \"64\",
        \"names\": {
          \"full\": \"Manhattan College\",
          \"short\": \"Manhattan\",
          \"seo\": \"manhattan\",
          \"char6\": \"MANHAT\",
          \"char8\": \"\",
          \"char10\": \"\"
        },
        \"description\": \"(25-7)\",
        \"iconURL\": \"/sites/default/files/images/logos/schools/m/manhattan.70.png\",
        \"radioUrl\": \"\",
        \"isTop\": \"F\",
        \"winner\": \"false\"
      }}", :symbolize_names => true) }
    let (:parsed_game) { Game.from_json(json) }

    it "can parse a game" do
      expect(parsed_game.teams).to eq ["Louisville", "Manhattan"]
      expect(parsed_game.round).to eq 2
      expect(parsed_game.winner).to eq "Louisville"
      expect(parsed_game.loser).to eq "Manhattan"
      expect(parsed_game.completed).to eq true
    end
  end
end
