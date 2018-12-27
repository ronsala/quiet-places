class UsersController < ApplicationController

  get '/signup' do
    # binding.pry
    if !logged_in?
      erb :"/users/signup"
    else
      redirect '/places'
    end
  end

  post '/signup' do
    # binding.pry
    # pry(#<UsersController>)> params
    # => {"username"=>"skittles123", "email"=>"skittles@aol.com", "password"=>"rainbows", "password_confirm"=>"rainbows"}
    # logged in?
    if logged_in?
      binding.pry # no hit
      redirect '/places'
    # not logged in
    else
      # binding.pry
      #       pry(#<UsersController>)> params
      # => {"username"=>"skittles123", "email"=>"skittles@aol.com", "password"=>"rainbows", "password_confirm"=>"rainbows"}
      # mismatched password entry?
      if params[:password] != params[:password_confirm]
        flash[:match] = "Passwords must match. Please try again."
        # binding.pry
        # pry(#<UsersController>)> params
        # => {"username"=>"skittles123", "email"=>"", "password"=>"rainbows"}
        redirect '/signup'
      # no mismatched password entry
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
      binding.pry
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
    # binding.pry #  params
    # => {"username"=>"becky567", "password"=>"kittens"}
    @user = User.find_by(:username => params[:username])
    # binding.pry # @user
    # => #<User:0x007fa73b0f70c8
    # id: 1,
    # username: "becky567",
    # email: "starz@aol.com",
    # password_digest: "$2a$10$Cz81qDv.MMAt7I6ROdVhH.IjCD8yYnYaxX0Bkcr6qAsmLkGO1KKT.",
    # is_admin: false,
    # created_at: 2018-12-09 14:04:41 UTC,
    # updated_at: 2018-12-09 14:04:41 UTC>
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      # binding.pry # session
      # => {"session_id"=>"280c71f8d89b9b2a194379a87253a476b8995f9a061fb6e4a38ed70b6ab9ab25", "csrf"=>"aKY4WGm6aKflx0SJJbAXNngItiPlXrjM0GE2BgD8thM=", "tracking"=>{"HTTP_USER_AGENT"=>"da39a3ee5e6b4b0d3255bfef95601890afd80709", "HTTP_ACCEPT_LANGUAGE"=>"da39a3ee5e6b4b0d3255bfef95601890afd80709"}, "user_id"=>1}
      redirect '/places'
    else
      redirect '/signup'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
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
