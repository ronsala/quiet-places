class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :"/users/signup"
    else
      redirect '/places'
    end
  end

  post '/signup' do
    if params[:password] != params[:password_confirm]
      # [] flash[:match] = "Passwords must match. Please try again."
    end
    @user = User.create(username: params[:username], email: params[:email], password: params[:password])
    # [] use flash instead of users/error?
    if @user.errors.any?
      erb :'users/error'
    else
      if params[:admin_key]
        if params[:admin_key] == ENV["ADMIN_KEY"]
          @user.is_admin = true
        else
          erb :'users/error' # [] or flash message?
        end
      end
      session[:user_id] = @user.id
      redirect '/places'
    end
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/places'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/places'
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
