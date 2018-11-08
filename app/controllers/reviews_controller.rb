class ReviewsController < ApplicationController

  get "/reviews" do
    redirect_if_not_logged_in
    @reviews = Review.all
    erb :"/reviews/index.html"
  end

  get "/reviews/new" do
    redirect_if_not_logged_in
    erb :"/reviews/new.html"
  end

  post "/reviews" do
    redirect_if_not_logged_in
    unless Review.valid_params?(params)
      redirect "/reviews/new?error=Please include all required fields."
    end
    Review.create(params)
    redirect "/reviews"
  end

  get "/reviews/:id" do
    redirect_if_not_logged_in
    erb :"/reviews/show.html"
  end

  get "/reviews/:id/edit" do
    redirect_if_not_logged_in
    erb :"/reviews/edit.html"
  end

  patch "/reviews/:id" do
    redirect_if_not_logged_in
    redirect "/reviews/:id"
  end

  delete "/reviews/:id/delete" do
    redirect_if_not_logged_in
    redirect "/reviews"
  end
end
