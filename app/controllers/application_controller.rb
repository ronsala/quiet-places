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
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      if logged_in?
        User.find(session[:user_id])
      else
        erb :index
      end
    end

    def redirect_if_not_logged_in
      if !logged_in?
        redirect '/'
      end
    end

    def is_admin
      current_user.is_admin
    end
  end

end
