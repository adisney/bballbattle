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
set :bracket_file,  "data/bracket.json"
set :picks_file, "data/picks.csv"
set :manager, nil

def hire_manager
  if File.exists?(settings.bracket_file) && File.exists?(settings.picks_file)
    settings.manager = Manager.new(settings.picks_file, settings.bracket_file)
  end
end

get '/' do
  File.read('public/index.html')
end

get '/picks' do
    Picks.new(settings.picks_file, settings.bracket_file).to_json
end

get '/history' do
  File.read('data/history/' + params[:year] + '.json')
end

get '/update_bracket' do
  Bracket.write_bracket(settings.bracket_file)
end

get '/teams' do
  Bracket.new(settings.bracket_file).get_teams.to_json
end

get '/player' do
  if settings.manager
    settings.manager.get(params[:name])
  else
    hire_manager
  end
end

post '/update' do
  if settings.manager
    settings.manager.update(params[:name], params[:picks])
    settings.manager.save_picks
  else
    hire_manager
  end
end

get '/ideas' do
  require 'open-uri'
  open('http://localhost:9001/p/idea-pad').read
end
