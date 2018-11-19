class ReviewsController < ApplicationController

  get "/reviews" do
    if !logged_in?
      erb :'users/login'
    else
      @reviews = Review.all
      erb :"/reviews/index"
    end
  end

  get "/reviews/new" do
    # test logged_in?
    erb :"/reviews/new.html"
  end

  post "/reviews" do
    # test logged_in?
    unless Review.valid_params?(params)
      redirect "/reviews/new?error=Please include all required fields."
    end
    Review.create(params)
    redirect "/reviews"
  end

  get "/reviews/:id" do
    # test logged_in?
    erb :"/reviews/show.html"
  end

  get "/reviews/:id/edit" do
    # test logged_in?
    erb :"/reviews/edit.html"
  end

  patch "/reviews/:id" do
    # test logged_in?
    redirect "/reviews/:id"
  end

  delete "/reviews/:id/delete" do
    # test logged_in?
    redirect "/reviews"
  end
end
