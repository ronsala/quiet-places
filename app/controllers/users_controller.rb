class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :"/users/signup"
    else
      redirect '/reviews/index'
    end
  end

  post '/signup' do
      @user = User.create!(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect '/reviews/index.html.erb'
    # end
  end


  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/reviews/index.html.erb'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/reviews/index.html.erb'
    else
      redirect '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end
end
