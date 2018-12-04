class PlacesController < ApplicationController

  get "/places" do
    @places = Place.all.order(:name)
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
      @place.user_id = current_user.id
      @place.save
      @user = User.find(@place.user_id)
      @user.places << @place
      @user.save
      redirect "/places/#{@place.id}"
    end
  end

  get "/places/:id/edit" do
    redirect_if_not_logged_in
    @place = Place.find(params[:id])
    erb :"/places/edit"
  end

  post "/places/:id" do
    redirect_if_not_logged_in 
    @place = Place.find(params[:id])
    unless params[:name] == ""
      @place.update(name: params[:name])
    end
    unless params[:street] == ""
      @place.update(street: params[:street])
    end
    unless params[:city] == ""
      @place.update(city: params[:city])
    end
    unless params[:state] == "--"
      @place.update(state: params[:state])
    end
    unless params[:category] == ""
      @place.update(category: params[:category])
    end
    unless params[:website] == ""
      @place.update(website: params[:website])
    end
    # @place.update(name: params[:name], street: params[:street], city: params[:city], state: params[:state], category: params[:category], website: params[:website])
    redirect "/places/#{@place.id}"
  end

  delete "/places/:id/delete" do
    redirect_if_not_logged_in
    redirect "/places"
  end

  get "/places/:id" do
    @place = Place.find(params[:id])
    erb :"/places/show"
  end

  patch "/places/:id" do
    redirect_if_not_logged_in
    redirect "/places/:id"
  end
end
