class PlacesController < ApplicationController

  get "/places" do
    redirect_if_not_logged_in
    @places = Place.all
    erb :"/places/index"
  end

  get "/places/new" do
    redirect_if_not_logged_in
    erb :"/places/new"
  end

  post "/places/new" do
    redirect_if_not_logged_in
    @place = Place.create(name: params[:name], street: params[:street], city: params[:city], state: params[:state], category: params[:category], website: params[:website])
    # if @place.errors.any?
    #   if @user.errors.messages[:username]
    #     flash[:place_error] = "Username #{@user.errors.messages[:username][0]}. Please try again."
    #   elsif @user.errors.messages[:email]
    #     flash[:email] = "Email #{@user.errors.messages[:email][0]}. Please try again."
    #   elsif @user.errors.messages[:password]
    #     flash[:password] = "Password #{@user.errors.messages[:password][0]}. Please try again."
    #   end
    #   redirect '/signup'
    # end
    redirect "/places"
  end

  get "/places/:id" do
    redirect_if_not_logged_in
    erb :"/places/show.html"
  end

  get "/places/:id/edit" do
    redirect_if_not_logged_in
    erb :"/places/edit.html"
  end

  patch "/places/:id" do
    redirect_if_not_logged_in
    redirect "/places/:id"
  end

  delete "/places/:id/delete" do
    redirect_if_not_logged_in
    redirect "/places"
  end
end
