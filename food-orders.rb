require 'sinatra'
require 'sass'
require 'coffee_script'
require 'json'

# set up db
require 'mongoid'
Dir.glob('./models/*.rb').each {|file| require_relative file }
Mongoid.load!('./config/mongoid.yml')


get '/' do
  erb :index
end


post '/order' do
  order = Order.new(params)
  if order.save
    { message: 'Order Saved' }.to_json
  else
    { message: 'Order Not Saved' }.to_json
  end
end

get '/orders' do
  Order.all.to_json
end



# any asset routes
get '/stylesheets/:name.css' do |n|
  scss :"stylesheets/#{n}", :views => 'public'
end
get '/javascripts/app.js' do
  coffee :app, :views => 'public/javascripts'
end
