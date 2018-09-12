require 'sinatra/base'
require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

set :database, "sqlite3:makersbnb.db.sqlite3"

class Makersbnb < Sinatra::Base
  enable :sessions

  get '/' do
    erb :home, :layout => :layout
  end

  post '/' do
    password = BCrypt::Password.create(params[:password])
    Account.create({name: params[:name], email: params[:email], password: password})
    session[:user_id] = Account.find_by(email: params[:email]).id
    redirect '/properties'
  end

  get '/session/new' do
    erb :login
  end

  get '/session/delete' do
    p session
    session.clear
    p session
    redirect '/'
  end

  post '/session' do
    account = Account.find_by(email: params[:email])
    correct_password = BCrypt::Password.new(account.password)
    if correct_password.is_password?(params[:password])
      session[:user_id] = account.id
      redirect '/properties'
    else
      'PASSWORD REJECTED'
    end
  end

  get '/properties' do
    erb :'properties/index', :layout => :layout_logged_in
  end

  get '/properties/new' do
    erb :'properties/new', :layout => :layout_logged_in
  end

  post '/properties' do
    redirect '/properties'
  end

  get '/bookings' do
  end

  post '/bookings' do
  end

  run! if app_file == $0
end

require './lib/account.rb'
require './lib/property.rb'
