require 'rubygems'
require 'sinatra'

@user = []

get '/' do
	erb :show
end

get '/new' do
	erb :new
end

post '/new' do
	
end