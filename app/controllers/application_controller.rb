require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    register Sinatra::Flash
    set :session_secret, ENV["SECRET_KEY"]
  end

  get "/" do
    value = %x( echo 'hi' )
    erb :index
  end

  helpers do

    def check_admin_key
      if params[:admin_key] != ""
        if params[:admin_key] == ENV["ADMIN_KEY"]
          @user.is_admin = true
          @user.save
          session[:user_id] = @user.id
          redirect '/places'
        else
          flash[:admin_mismatch] = "Admin key not recognized. Please try again."
          redirect '/signup'
        end
      else
        login_user
      end
    end
    
    def confirm_password
      if params[:password] != params[:password_confirm]
        flash[:match] = "Passwords must match. Please try again."
        redirect '/signup'
      else
        @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      end
    end
    
    def current_user
      if logged_in?
        User.find_by(id: session[:user_id])
      end
    end

    def is_admin
      current_user.is_admin
    end

    def logged_in?
      !!session[:user_id]
    end

    def redirect_if_not_logged_in
      if !logged_in?
        redirect '/'
      end
    end

  end

end
