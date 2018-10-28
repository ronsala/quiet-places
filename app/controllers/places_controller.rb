class PlacesController < ApplicationController

  # GET: /places
  get "/places" do
    erb :"/places/index.html"
  end

  # GET: /places/new
  get "/places/new" do
    erb :"/places/new.html"
  end

  # POST: /places
  post "/places" do
    redirect "/places"
  end

  # GET: /places/5
  get "/places/:id" do
    erb :"/places/show.html"
  end

  # GET: /places/5/edit
  get "/places/:id/edit" do
    erb :"/places/edit.html"
  end

  # PATCH: /places/5
  patch "/places/:id" do
    redirect "/places/:id"
  end

  # DELETE: /places/5/delete
  delete "/places/:id/delete" do
    redirect "/places"
  end
end
