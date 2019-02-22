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

  get "/users/:id/edit" do
    @user = User.find(params[:id])
    unless current_user == @user || current_user.is_admin?
      redirect "/"
    end
    erb :"/users/edit"
  end

  get "/users/:id" do
    @user = User.find(params[:id])
    @places = @user.places.sort_by { |place | place.name }
    @reviews = @user.reviews.sort_by { | review | [ review.place.name.downcase, review.title.downcase ] }
    erb :"/users/show"
  end

  patch "/users/:id" do
    @user = User.find(params[:id])

    unless current_user == @user || current_user.is_admin?
      redirect "/"
    end

    if params[:password] != params[:password_confirm]
      flash[:match] = "Passwords must match. Please try again."
      redirect request.referrer
    end

    @user.errors.clear

    @user.update(username: params[:username], email: params[:email])

    if @user.errors.any? 
      if @user.errors.messages[:username]
        flash[:username] = "Name #{@user.errors.messages[:username][0]}. Please try again."
      elsif @user.errors.messages[:email]
        flash[:email] = "Email #{@user.errors.messages[:email][0]}. Please try again."
      elsif @user.errors.messages[:password]
        flash[:password] = "Password #{@user.errors.messages[:password][0]}. Please try again."
      end
      redirect "/users/:id/edit"
    end

      check_admin_key
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
    if @user
      if @user == current_user || current_user.is_admin?
        session.clear

        @user.reviews.each do | review |
          review.delete
        end

        @user.places.each do | place |
          place.reviews.each do | review |
            review.delete
          end
        end

        @user.places.each do | place |
          place.delete
        end

        @user.delete
      end
    end
    redirect "/"
  end
end
