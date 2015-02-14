require 'bracket'

describe "bracket" do
  let (:matchup_json) { 
    "{
      \"contestId\": \"446109\",
      \"bracketPositionId\": \"101\",
      \"away\": {
        \"score\": \"71\",
        \"names\": {
          \"full\": \"University at Albany\",
          \"short\": \"Albany\",
          \"seo\": \"albany-ny\",
          \"char6\": \"ALBANY\",
          \"char8\": \"\",
          \"char10\": \"\"
        },
        \"description\": \"(18-14)\",
        \"iconURL\": \"/sites/default/files/images/logos/schools/a/albany-ny.70.png\",
        \"radioUrl\": \"\",
        \"isTop\": \"T\",
        \"winner\": \"true\"
      },
      \"currentPeriod\": \"Final\",
      \"finalMessage\": \"Final\",
      \"gameDate\": \"TUESDAY  , MARCH    18\",
      \"gameDateShort\": \"MAR. 18\",
      \"startTime\": \"06:30PM ET\",
      \"startTimeShort\": \"06:30P.M.\",
      \"startTimeEpoch\": \"1395181800\",
      \"gameState\": \"final\",
      \"home\": {
        \"score\": \"64\",
        \"names\": {
          \"full\": \"Mount St. Mary's University\",
          \"short\": \"Mt. St. Mary's\",
          \"seo\": \"mt-st-marys\",
          \"char6\": \"MTSTMY\",
          \"char8\": \"\",
          \"char10\": \"\"
        },
        \"description\": \"(16-16)\",
        \"iconURL\": \"/sites/default/files/images/logos/schools/m/mt-st-marys.70.png\",
        \"radioUrl\": \"\",
        \"isTop\": \"F\",
        \"winner\": \"false\"
      },
      \"timeclock\": \"0:00\",
      \"round\": \"1\",
      \"location\": \"University of Dayton Arena, Dayton, Ohio\",
      \"network\": \"truTV\",
      \"url\": \"/game/basketball-men/d1/2014/03/18/albany-ny-mt-st-marys\",
      \"liveStatsEnabled\": \"1\",
      \"previewUrl\": \"\",
      \"watchLiveUrl\": \"http://www.ncaa.com/march-madness-live/game/101\",
      \"gameCenterUrl\": \"\",
      \"externalStatsUrl\": \"\",
      \"liveVideoExternalUrl\": \"\",
      \"nationalRadioUrl\": \"\",
      \"boxScoreUrl\": \"\",
      \"recapUrl\": \"http://www.ncaa.com/game/basketball-men/d1/2014/03/18/albany-ny-mt-st-marys/recap\",
      \"highlightUrl\": \"http://www.ncaa.com/march-madness/real-time-highlights/game/101\",
      \"ticketsUrl\": \"\",
      \"seedTop\": \"16\",
      \"seedBottom\": \"16\",
      \"textOverrideTop\": null,
      \"textOverrideBottom\": null
    }" }
  let (:matchup) { JSON.parse(matchup_json) }

  describe "producing team details" do
    let (:bracket_file) { "data/test_bracket.json" }
    let (:teams) { get_team_details(bracket_file) }
    let (:louisville) {teams.values.find {|team| team[:name] == "Louisville"}}
    let (:pitt) {teams.values.find {|team| team[:name] == "Pittsburgh"}}

    it "should get team names" do
      names = teams.map {|key, team| team[:name]}
      #expect(names.length).to eq (68)
      expect(names).to include ("Albany")
      expect(names).to include ("Mercer")
      expect(names).to include ("Mt. St. Mary's")
      expect(names).to include ("Ohio State")
      expect(names).to include ("Louisville")
      expect(names).to include ("Michigan")
    end

    it "gets team seed" do
      expect(louisville[:seed]).to eq 4
      expect(pitt[:seed]).to eq 9
    end

    it "gets name of logo" do
      expect(louisville[:logo]).to eq "louisville.70.png"
      expect(pitt[:logo]).to eq "pittsburgh.70.png"
    end
  end

  describe "producing matchups" do
    let (:matchups) { get_matchups("data/test_bracket.json") }
    let (:teams) { matchups[1][0][:teams] }

    it "gets matchups by round" do
      expect(matchups[1].size()).to eq 4 
      expect(matchups[2].size()).to eq 32 
      expect(matchups[3].size()).to eq 16 
      expect(matchups[4].size()).to eq 8 
      expect(matchups[5].size()).to eq 4 
      expect(matchups[6].size()).to eq 2 
      expect(matchups[7].size()).to eq 1 
    end

    it "gets game state" do
      expect(matchups[1][0][:state]).to eq "final"
      expect(matchups[4][0][:state]).to eq "pre"
    end
    
    describe "team details" do
      it "gets competitors" do
        expect(teams[0][:name]).to eq "Albany"
        expect(teams[1][:name]).to eq "Mt. St. Mary's"
      end

      it "gets the winner" do
        expect(teams[0][:winner]).to eq true
        expect(teams[1][:winner]).to eq false 
      end

      it "gets the score" do
        expect(teams[0][:score]).to eq 71
        expect(teams[1][:score]).to eq 64 
      end
    end
  end
end
