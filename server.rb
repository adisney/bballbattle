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
    sleep 600
    write_html
  end
end

get '/' do
  File.read('totals.html')
end

get '/picks' do
  pick_details
end
