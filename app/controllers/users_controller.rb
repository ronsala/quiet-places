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
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      if @user.errors.any?
        if @user.errors.messages[:username]
          flash[:user] = "Username #{@user.errors.messages[:username][0]}. Please try again."
        elsif @user.errors.messages[:email]
          flash[:email] = "Email #{@user.errors.messages[:email][0]}. Please try again."
        elsif @user.errors.messages[:password]
          flash[:password] = "Password #{@user.errors.messages[:password][0]}. Please try again."
        end
        redirect '/signup'
      else
        if params[:admin_key] != ""
          if params[:admin_key] == ENV["ADMIN_KEY"]
            @user.is_admin = true
            binding.pry
            @user.save
            session[:user_id] = @user.id
            redirect '/places'
          else
            flash[:admin_mismatch] = "Admin key not recognized. Please try again."
            redirect '/signup'
          end
        else
          session[:user_id] = @user.id
          redirect '/places'
        end
      end
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
