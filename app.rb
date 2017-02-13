require 'rubygems'
require 'sinatra'
require 'pry'
require 'bundler'
Bundler.require()
require './models/user'

# Connection
ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'all_users'
})
#

get '/' do
	@title = "Show all users"
	@users = User.all.order(:id)

	erb :show
end

get '/new' do
	@title = "Create new user"
	erb :new
end

post '/new' do
	file = params[:file][:tempfile]
	File.open("./public/images/#{ User.count+1 }", 'wb') do |f|
		f.write(file.read)
	end
	params[:user][:avatar] = User.count+1
	@user = User.create(params[:user])
	redirect '/'
end

get '/edit/:id' do
	@title = "Edit user"
	erb :edit
end

put '/edit/:id' do
	file = params[:file][:tempfile]
	user = User.find_by id: params[:id]
	if file != nil
		File.delete("./public/images/#{user.avatar}")
		File.open("./public/images/#{user.avatar}", 'w') do |f|
			f.write(file.read)
		end
	end
	user.update(params[:user])
	redirect '/'
end

delete '/:id' do
	user = User.find_by id: params[:id]
	File.delete("./public/images/#{user.avatar}")
	User.delete(params[:id])
	redirect '/'
end