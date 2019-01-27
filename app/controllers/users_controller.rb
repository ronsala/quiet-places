class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :"/users/signup"
    else
      redirect '/places'
    end
  end

  # [] Refactor this:
  post '/signup' do
    if logged_in?
      redirect '/places'
    # not logged in
    else
      if params[:password] != params[:password_confirm]
        flash[:match] = "Passwords must match. Please try again."
        redirect '/signup'
      else
        # create user
        @user = User.create(username: params[:username], email: params[:email], password: params[:password])

        # user errors?
        if @user.errors.any?
          # data in errors hash?
          if @user.errors.messages[:username]
            flash[:user] = "Username #{@user.errors.messages[:username][0]}. Please try again."
          elsif @user.errors.messages[:email]
            flash[:email] = "Email #{@user.errors.messages[:email][0]}. Please try again."
          elsif @user.errors.messages[:password]
            flash[:password] = "Password #{@user.errors.messages[:password][0]}. Please try again."
          end # data in errors hash?
          redirect '/signup'
        # no user errors
        else
          # something in admin key field?
          if params[:admin_key] != ""
            # correct admin creds?
            if params[:admin_key] == ENV["ADMIN_KEY"]
              @user.is_admin = true
              @user.save
              session[:user_id] = @user.id
              redirect '/places'
            else
              # handle incorrect admin cred
              flash[:admin_mismatch] = "Admin key not recognized. Please try again."
              redirect '/signup'
            end # correct admin creds?
          # nothing in admin field
          else
            # log in regular user
            session[:user_id] = @user.id
            redirect '/places'
          end # something in admin key field?
        end # user errors?
      end # mismatched password entry?
    end # logged in?
  end

  get "/users/:id" do
    redirect_if_not_logged_in
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
