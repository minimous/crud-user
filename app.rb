require 'rubygems'
require 'sinatra'
require 'pry'
require 'bundler'
Bundler.require()
require './models/user'
require './models/book'
require './models/bookreview'

# Connection
ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'all_users'
})
#

enable :sessions
set :session_secret, "secret"

#set :static_cache_control, [:public, max_age: 0]

get '/' do
	@title = "Show all users"
	@users = User.all.order(:id)
	# binding.pry
	erb :index
end

get '/new' do
	@title = "Create new user"
	erb :new
end

post '/new' do
	file = params[:file][:tempfile] if params[:file][:tempfile] != nil
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
	user = User.find_by id: params[:id]
	if params[:file] != nil
		file = params[:file][:tempfile]
		File.delete("./public/images/#{user.avatar}") if File.exist?("./public/images/#{user.avatar}")
		File.open("./public/images/#{params[:user][:email]}", 'w') do |f|
			f.write(file.read)
		end
	else
		if user.email != params[:user][:email]
			if File.exist?("./public/images/#{user.avatar}")
				File.rename("./public/images/#{user.avatar}","./public/images/#{params[:user][:email]}")
			end
		end
	end
	user.update(
		name: params[:user][:name],
		email: params[:user][:email],
		password: params[:user][:password],
		avatar: params[:user][:email],
		about: params[:user][:about]
	)
	redirect '/'
end

delete '/:id' do
	user = User.find_by id: params[:id]
	File.delete("./public/images/#{user.avatar}") if File.exist?("./public/images/#{user.avatar}")
	User.delete(params[:id])
	redirect '/'
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

get '/login' do
	@title = "Login"
	erb :login
end

post '/login' do
	user = User.find_by email: params[:email]
	if user.nil? ||  user.password != params[:password]
		@alert = "Invalid email or password."
		erb :login
	else 
		session[:user] = user
		redirect '/info'
	end
end

get '/info' do
	if session[:user].nil?
		redirect '/login'
	else
		@title = "Personal Information"
		@user = session[:user]
		@books = Book.book_from_user(@user.id).all
		erb :info
	end
end

get '/logout' do
	session.clear
	redirect '/'
end

get '/newbook' do
	if session[:user].nil?
		redirect '/login'
	else
		@title = "Add new book"
		@user = session[:user]
		erb :newbook
	end
end

post '/newbook' do
	@book = Book.create(
		user_id: session[:user][:id],
		title: params[:title],
		publisher: params[:publisher],
		year: params[:year]
	)
	redirect '/info'
end

get '/editbook/:id' do
	@title = "Edit Book"
	@book = Book.find_by book_id: params[:id]
	erb :editbook
end

put '/editbook/:id' do
	book = Book.find_by book_id: params[:id]
	book.update(params[:book])
	redirect '/info'
end

delete '/deletebook/:id' do
	Book.delete(params[:id])
end

get '/book/:id' do
	@book = Book.find_by book_id: params[:id]
	@title = "Book Detail"
	@reviews = BookReview.find_all_reviews @book.book_id
	session[:book] = @book
	erb :book
end

post '/review' do
	@review = BookReview.create(
		user_id: session[:user][:id],
		book_id: session[:book][:book_id],
		star: params[:star].keys.first.to_i,
		subject: params[:subject],
		content: params[:content]
	)
	redirect '/book/'+session[:book][:book_id].to_s
end