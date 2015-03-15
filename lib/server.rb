$:.unshift File.join(File.dirname(__FILE__))

require 'sinatra'
require 'date'
require 'picks'
require 'bracket'
require 'manage'

set :static, true
set :bind, '0.0.0.0'
set :port, 8080
set :public_folder, './public'
set :manager, Manager.new("data/picks.csv", "data/bracket.json")

def write_bracket
  puts get_current_time
  puts "starting..."
  file = File.open("data/bracket.json", "w")
  file.write(get_bracket.to_json)
  file.close
  puts "done"
end

get '/' do
  File.read('public/index.html')
end

get '/picks' do
  Picks.new("data/picks.csv", "data/bracket.json").to_json
end

get '/history' do
  File.read('data/history/' + params[:year] + '.json')
end

get '/update_bracket' do
  write_bracket
end

get '/teams' do
  Bracket.new('data/bracket.json').get_teams.to_json
end

get '/player' do
  settings.manager.get(params[:name])
end

post '/update' do
  settings.manager.update(params[:name], params[:picks])
  settings.manager.save_picks
end

get '/ideas' do
  require 'open-uri'
  open('http://localhost:9001/p/idea-pad').read
end
