class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :"/users/signup"
    else
      redirect '/places'
    end
  end

  post '/signup' do
    if logged_in?
      redirect '/places'
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      check_errors
    end
  end

  get "/users/:id" do
    @user = User.find(params[:id])
    @places = @user.places
    @reviews = @user.reviews
    erb :"/users/show"
  end

  get "/users/:id/edit" do
    @user = User.find(params[:id])
    unless current_user == @user || current_user.is_admin
      redirect "/"
    end
    erb :"/users/edit"
  end

  post "/users/:id" do
    @user = User.find(params[:id])

    unless current_user == @user || current_user.is_admin
      redirect "/"
    end

    @reviews = @user.reviews
    @user.errors.clear

    unless params[:password] == params[:password_confirm]
      binding.pry
      redirect "/users/#{@user.id}/edit"
    end

    unless params[:username] == ""
      @user.update(username: params[:username])
    end

    unless params[:email] == ""
      @user.update(email: params[:email])
    end

    unless params[:password] == "" || 
      @user.update(password: params[:password])
    end

    if @user.errors.messages != {}
      flash[:messages] = "#{@user.errors.full_messages[0]}. Please try again."
      redirect "/users/#{@user.id}/edit"
    else
      redirect "/users/#{@user.id}"
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

  get "/users/:id/delete" do
    @user = User.find(params[:id])
    if @user && @user == current_user
      session.clear
      @user.delete
    end
    redirect "/"
  end
end
