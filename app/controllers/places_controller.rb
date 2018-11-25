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
    if @place.errors.any?
      if @place.errors.messages[:name]
        flash[:name] = "Name #{@place.errors.messages[:name][0]}. Please try again."
      elsif @place.errors.messages[:street]
        flash[:street] = "Street #{@place.errors.messages[:street][0]}. Please try again."
      elsif @place.errors.messages[:city]
        flash[:city] = "City #{@place.errors.messages[:city][0]}. Please try again."
      end
      redirect '/places/new'
    else
      redirect "/places/#{@place.id}"
    end
  end

  get "/places/:id" do
    redirect_if_not_logged_in
    erb :"/places/show"
  end

  get "/places/:id/edit" do
    redirect_if_not_logged_in
    erb :"/places/edit"
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
