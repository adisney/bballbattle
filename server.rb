$:.unshift File.join(File.dirname(__FILE__))

require 'sinatra'
require 'ncaa_challenge'

set :static, true

def write_html
  puts "starting..."
  file = open("totals.html", "w")
  file.write(generate_html)
  file.close()
  puts "done"
end

Thread.new do
  while true do
    #write_html
    sleep 600
    file = File.open("bracket.json", "w")
    file.write(get_bracket.to_json)
    file.close
  end
end

get '/' do
  File.read('public/index.html')
end

get '/picks' do
  bracket = JSON.parse(File.read("bracket.json"), {:symbolize_names => true})
  pick_details(bracket).to_json
end
