class Team
  attr_accessor :name, :seed, :logo, :knocked_out, :points

  SEED_TO_POINTS = {
                  1 => 1,
                  2 => 2,
                  3 => 2,
                  4 => 3,
                  5 => 3,
                  6 => 4,
                  7 => 4,
                  8 => 4,
                  9 => 5,
                  10 => 5,
                  11 => 5,
                  12 => 6,
                  13 => 6,
                  14 => 7,
                  15 => 7,
                  16 => 8
                  }

  def initialize(name, seed, logo_file)
    @name = name
    @seed = seed
    @logo = logo_file
    @knocked_out = false
    @points = 0
  end

  def self.from_json(json, side)
    team = json[side]
    name = team[:names][:short]
    seed = team[:isTop] == "T" ? json[:seedTop].to_i : json[:seedBottom].to_i
    logo = team[:iconURL].split('/')[8]

    Team.new(name, seed, logo)
  end

  def won_game
    @points += SEED_TO_POINTS[@seed]
  end

  def lost_game
    @knocked_out = true
  end
end
