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
    if @review.errors.any?
      if @review.errors.messages[:title]
        flash[:title] = "Title #{@review.errors.messages[:title][0]}. Please try again."
      elsif @review.errors.messages[:body]
        flash[:body] = "Review body #{@review.errors.messages[:body][0]}. Please try again."
      end
      redirect '/reviews/new'
    else
      @review.user_id = current_user.id
      @review.save
      @place = Place.find(@review.place_id)
      @place.reviews << @review
      @place.save
      @user = User.find(@review.user_id)
      @user.reviews << @review
      @user.save
      redirect "/reviews/#{@review.id}"
    end
  end

  get "/reviews/:id" do
    redirect_if_not_logged_in
    @review = Review.find(params[:id])
    # binding.pry
    @place = Place.find(@review.place_id)
    @user = User.find(@review.user_id)
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
