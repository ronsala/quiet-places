class ReviewsController < ApplicationController

  get "/reviews" do
    
    @reviews = Review.all.sort_by { | review | [ review.place.name.downcase, review.title.downcase ] }

    erb :"/reviews/index"
  end

  get "/reviews/new/:id" do
    redirect_if_not_logged_in
    @place = Place.find(params[:id])
    erb :"/reviews/new"
  end

  get "/reviews/new" do
    redirect_if_not_logged_in
    @places = Place.all.order(:name)
    erb :"/reviews/new"
  end

  post "/reviews" do
    redirect_if_not_logged_in
    @review = Review.create(place_id: params[:place_id], title: params[:title], tv: params[:tv], volume: params[:volume], quality: params[:quality], body: params[:body])
    if @review.errors.any?
      if @review.errors.messages[:title]
        flash[:title] = "Title #{@review.errors.messages[:title][0]}. Please try again."
      elsif @review.errors.messages[:body]
        flash[:body] = "Review body #{@review.errors.messages[:body][0]}. Please try again."
      end
      redirect request.referrer
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
    @review = Review.find(params[:id])
    @place = Place.find(@review.place_id)
    @user = User.find(@review.user_id)
    erb :"/reviews/show"
  end

  get "/reviews/:id/edit" do
    redirect_if_not_logged_in
    @review = Review.find_by(:id => params[:id])
    @place = Place.find_by(@review.place_id)
    if current_user.id == @review.user_id || current_user.is_admin
      erb :"/reviews/edit"
    else
      redirect '/'
    end
  end

  patch "/reviews/:id" do
    @review = Review.find(params[:id])
    unless current_user == @review.user || current_user.is_admin
      redirect "/"
    end
    @review.errors.clear
    unless params[:title] == ""
      @review.update(title: params[:title])
    end
    unless params[:tv] == "--"
      @review.update(tv: params[:tv])
    end
    unless params[:volume] == "--"
      @review.update(volume: params[:volume])
    end
    unless params[:quality] == "--"
      @review.update(quality: params[:quality])
    end
    unless params[:body] == ""
      @review.update(body: params[:body])
    end
    if @review.errors.messages != {}
      flash[:messages] = "#{@place.errors.full_messages[0]}. Please try again."
      redirect "/reviews/#{@review.id}/edit"
    else
      redirect "/reviews/#{@review.id}"
    end
  end

  get "/reviews/:id/delete" do
    @review = Review.find_by(id: params[:id])
    if @review
      if @review.user == current_user || current_user.is_admin?
        @review.delete
      end
    end
    redirect "/reviews"
  end
end
