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
      flash[:match] = "Passwords must match. Please try again."
      redirect '/signup'
    end
    @user = User.create(username: params[:username], email: params[:email], password: params[:password])
    if @user.errors.any?
      if @user.errors.messages[:username]
        flash[:user] = "Username #{@user.errors.messages[:username][0]}. Please try again."
      end
      # binding.pry
      # erb :'users/error'
      redirect '/signup'
    else
      if params[:admin_key]
        if params[:admin_key] == ENV["ADMIN_KEY"]
          @user.is_admin = true
          @user.save
        else
          erb :'users/error' # [] or flash message?
        end
      end
      session[:user_id] = @user.id
      redirect '/places'
    end
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
    session.clear
    redirect '/'
  end
end
