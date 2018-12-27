require_relative "spec_helper"

def app
  ApplicationController
end

describe ApplicationController do
  it "responds with a welcome message" do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Welcome To Quiet Places!")
  end
end

[] ##########
  
  # describe "logout" do
  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      # visit '/logout'
      # follow_redirect!
      # page.save_and_open_page
      # blank page
      # expect(page.current_path).to eq('/')
      # expect(page).to have_content("Welcome")
      expect(page).to have_current_path("/login")
      expect(last_response.location).to include("/login")
    end
  end