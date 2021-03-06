class PlacesController < ApplicationController

  get "/places" do
    @places = Place.all.order(:name)
    erb :"/places/index"
  end
  
  get "/places/new" do
    redirect_if_not_logged_in
    erb :"/places/new"
  end

  post "/places" do
    redirect_if_not_logged_in
    @place = Place.new(name: params[:name], street: params[:street], city: params[:city], state: params[:state], category: params[:category], website: params[:website])

    if @place.invalid?
      
      if @place.errors.messages[:name]
        flash[:name] = "Name #{@place.errors.messages[:name][0]}. Please try again."
      elsif @place.errors.messages[:street]
        flash[:street] = "Street #{@place.errors.messages[:street][0]}. Please try again."
      elsif @place.errors.messages[:city]
        flash[:city] = "City #{@place.errors.messages[:city][0]}. Please try again."
      elsif @place.errors.messages[:state]
        flash[:state] = "State #{@place.errors.messages[:state][0]}. Please try again."
      end

      redirect '/places/new'  
    else
      @place.user_id = current_user.id
      @user = User.find(@place.user_id)
      @place.save
      @user.places << @place
      @user.save
      redirect "/places/#{@place.id}"
    end
  end

  get "/places/:id" do
    @place = Place.find(params[:id])
    @reviews = @place.reviews.sort_by { | review | review.title }
    erb :"/places/show"
  end

  get "/places/:id/edit" do
    @place = Place.find(params[:id])
    unless current_user == @place.user || current_user.is_admin
      redirect "/"
    end
    erb :"/places/edit"
  end

  patch "/places/:id" do
    @place = Place.find(params[:id])

    unless current_user == @place.user || current_user.is_admin
      redirect "/"
    end

    @place.errors.clear

    @place.update(name: params[:name], street: params[:street], city: params[:city], state: params[:state], category: params[:category], website: params[:website])

    if @place.errors.any? 
      if @place.errors.messages[:name]
        flash[:name] = "Name #{@place.errors.messages[:name][0]}. Please try again."
      elsif @place.errors.messages[:street]
        flash[:street] = "Street #{@place.errors.messages[:street][0]}. Please try again."
      elsif @place.errors.messages[:city]
        flash[:city] = "City #{@place.errors.messages[:city][0]}. Please try again."
      elsif @place.errors.messages[:state]
        flash[:state] = "State #{@place.errors.messages[:state][0]}. Please try again."
      end

      redirect "/places/#{@place.id}/edit"
    else
      redirect "/places/#{@place.id}"
    end
  end

  get "/places/:id/delete" do
    @place = Place.find(params[:id])
    if @place.user == current_user || current_user.is_admin?
      @place.reviews.each do | review |
        review.delete
      end
      @place.delete
    end
    redirect "/places"
  end
end
