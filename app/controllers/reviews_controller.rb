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
    redirect_if_not_logged_in
    erb :"/reviews/new"
  end

  post "/reviews/new" do
    redirect_if_not_logged_in
    @review = Review.create(place_id: params[:place_id], title: params[:title], tv: params[:tv], volume: params[:volume], quality: params[:quality], body: params[:body])
    @review.user_id = current_user.id
    @review.save
    redirect "/reviews/#{@review.id}"
  end

  get "/reviews/:id" do
    redirect_if_not_logged_in
    erb :"/reviews/show"
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
