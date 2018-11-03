require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) } # from http://sinatrarb.com/intro.html
  end

  get "/" do
    erb :index
  end

  

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
