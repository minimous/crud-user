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

#set :static_cache_control, [:public, max_age: 0]

get '/' do
	@title = "Show all users"
	@users = User.all.order(:id)
	#binding.pry
	erb :show
end

get '/new' do
	@title = "Create new user"
	erb :new
end

post '/new' do
	file = params[:file][:tempfile]
	File.open("./public/images/#{ params[:user][:email] }", 'wb') do |f|
		f.write(file.read)
	end
	@user = User.create(
		name: params[:user][:name],
		email: params[:user][:email],
		password: params[:user][:password],
		avatar: params[:user][:email],
		about: params[:user][:about]
	)
	redirect '/'
end

get '/edit/:id' do
	@title = "Edit user"
	@user = User.find_by id: params[:id]
	erb :edit
end

put '/edit/:id' do
	file = params[:file][:tempfile]
	user = User.find_by id: params[:id]
	if file != nil
		File.delete("./public/images/#{user.avatar}") if File.exist?("./public/images/#{user.avatar}")
		File.open("./public/images/#{user.email}", 'w') do |f|
			f.write(file.read)
		end
	end
	user.update(params[:user])
	redirect '/'
end

delete '/:id' do
	user = User.find_by id: params[:id]
	File.delete("./public/images/#{user.avatar}") if File.exist?("./public/images/#{user.avatar}")
	User.delete(params[:id])
	redirect '/'
end

get '/images/:avatar' do
	cache_control :public, :no_cache
end

post '/search' do
	@title = "Search results"
	@users = User.search(params[:search]).all
	if @users.nil?
		"No user found !"
	else
		erb :show
	end
end