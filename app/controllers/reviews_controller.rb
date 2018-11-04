class ReviewsController < ApplicationController

  get "/places" do
    redirect_if_not_logged_in
    @places = Place.all
    erb :"/places/index.html"
  end

  get "/places/new" do
    redirect_if_not_logged_in
    erb :"/places/new.html"
  end

  post "/places" do
    redirect_if_not_logged_in
    unless Place.valid_params?(params)
      redirect "/places/new?error=Please include all required fields."
    end
    Place.create(params)
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
