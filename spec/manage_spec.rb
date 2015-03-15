require 'manage.rb'

describe "manage" do
  let ( :manager ) { Manager.new('picks_file', 'bracket_file') }
  let ( :bracket ) { double "bracket" }
  let (:file) { double "file" }

  before( :each ) do
    allow(Bracket).to receive(:new).and_return bracket
    allow(bracket).to receive(:get_teams).and_return({
      "Louisville" => Team.new("Louisville", 4, ""),
      "Oklahoma" => Team.new("Oklahoma", 5, ""),
      "Michigan State" => Team.new("Michigan State", 4, "")})
    allow(File).to receive(:readlines).and_return(["Alex D,Louisville,Oklahoma,Michigan State"])
    allow(File).to receive(:open).and_yield file
  end

  it "loads picks from file" do
    expect(File).to receive(:readlines)
    Manager.new('picks_file', 'bracket_file')
  end

  it "correctly loads players with no picks" do
    allow(File).to receive(:readlines).and_return(["Alex D,"])
    expect(manager.get "Alex D").to eq "[]"
  end

  it "returns the json seeded picks" do
    expect(manager.get "Alex D").to eq('["4. Louisville","5. Oklahoma","4. Michigan State"]')
  end

  it "creates an entry if player new" do
    expect(file).to receive(:puts).twice
    manager.get("Jon")
  end

  it "saves the players as a csv without seeds" do
    expect(file).to receive(:puts).with("Alex D,Louisville,Oklahoma,Michigan State")
    manager.save_picks
  end

  it "updates player picks" do
    manager.update("Alex D", ["4. Louisville","5. Oklahoma","4. Michigan State"])
    expect(manager.get "Alex D").to eq('["4. Louisville","5. Oklahoma","4. Michigan State"]')
  end
end
