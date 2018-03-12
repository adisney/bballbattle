#!/usr/bin/env ruby

require 'json'

def get_bracket()
    # based on bracket located at http://www.ncaa.com/interactive-bracket/basketball-men/d1
    response = %x[curl -s http://data.ncaa.com/carmen/brackets/championships/basketball-men/d1/2017/data.json]
    json = JSON.parse(response, {:symbolize_names => true})
    #json[:update_time] = get_current_time
    json
end

seeds_by_name = {}
bracket = get_bracket()
bracket[:games].each do |game|
    [:away, :home].each do |side|
        team = game[side]
        seed = team[:isTop] == "T" ? game[:seedTop].to_i : game[:seedBottom].to_i
        name = team[:names][:short]
        seeds_by_name[name] = seed
    end
end

history = [] 
picks = open('./data/picks_2017.csv', 'r')
picks.readlines.each do |line|
    split = line.split(',')
    player = split[0]
    teams = split[1..8] 
    details = {}
    details[:name] = player
    details[:picks] = []
    teams.each do |team|
        team = team.strip
        seed = seeds_by_name[team]
        details[:picks].push("#{seed}. #{team}")
    end

    history.push(details)
end

puts JSON.generate(history)

picks.close()
