# Adapted from Flatiron School's Fwitter spec

require_relative 'spec_helper'

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome To Quiet Places!")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      visit('/')
      click_link('Sign Up')
      expect(page).to have_content("Have an admin key?")
    end

    it 'signup directs user to places index' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows",
        :password_confirm => "rainbows"
      }
      post '/signup', params
      binding.pry
      expect(last_response.location).to include("/places")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "skittles@aol.com",
        :password => "rainbows",
        :password_confirm => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
    
    it 'does not let a user sign up without a password' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    # [] fix
    # it 'does not let a logged in user view the signup page' do
    #   user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
    #   params = {
    #     :username => "skittles123",
    #     :email => "skittles@aol.com",
    #     :password => "rainbows",
    #     :password_confirm => "rainbows"
    #   }
    #   # pry(#<RSpec::ExampleGroups::SignupPage>)> params
    #   # => {:username=>"skittles123", :email=>"skittles@aol.com", :password=>"rainbows", :password_confirm=>"rainbows"}
    #   post '/signup', params
    #   get '/signup'
    #   # follow_redirect! => Last response was not a redirect. Cannot follow_redirect!
    #   expect(last_response.body).to include("<h2>Places</h2>")
    #   expect(last_response.location).to include('/places')
    # end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the places index after login' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("<h2>Places</h2>")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/places")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      # [] ?To be more thorough: use click_link('/logout')
      get '/logout'
      follow_redirect!
      # binding.pry
      expect(last_response.body).to include("Log In")
      # expect(page.current_path).to eq('/')
      # expect(page).to have_content("Welcome")
      # expect(last_response.location).to include("/")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does load /places if user is logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/places')
    end
  end

  describe 'user show page' do
    it 'shows all a single users places' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet1 = Review.create(:content => "tweeting!", :user_id => user.id)
      tweet2 = Review.create(:content => "tweet tweet tweet", :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("tweeting!")
      expect(last_response.body).to include("tweet tweet tweet")

    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the places index if logged in' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet1 = Review.create(:content => "tweeting!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        tweet2 = Review.create(:content => "look at this tweet", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/places"
        expect(page.body).to include(tweet1.content)
        expect(page.body).to include(tweet2.content)
      end
    end

    context 'logged out' do
      it 'does not let a user view the places index if not logged in' do
        get '/places'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new tweet form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/places/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a tweet if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/places/new'
        fill_in(:content, :with => "tweet!!!")
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        tweet = Review.find_by(:content => "tweet!!!")
        expect(tweet).to be_instance_of(Review)
        expect(tweet.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user tweet from another user' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/places/new'

        fill_in(:content, :with => "tweet!!!")
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        tweet = Review.find_by(:content => "tweet!!!")
        expect(tweet).to be_instance_of(Review)
        expect(tweet.user_id).to eq(user.id)
        expect(tweet.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank tweet' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/places/new'

        fill_in(:content, :with => "")
        click_button 'submit'

        expect(Review.find_by(:content => "")).to eq(nil)
        expect(page.current_path).to eq("/places/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new tweet form if not logged in' do
        get '/places/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single tweet' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet = Review.create(:content => "i am a boss at tweeting", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/places/#{tweet.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Review")
        expect(page.body).to include(tweet.content)
        expect(page.body).to include("Edit Review")
      end
    end

    context 'logged out' do
      it 'does not let a user view a tweet' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet = Review.create(:content => "i am a boss at tweeting", :user_id => user.id)
        get "/places/#{tweet.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view tweet edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet = Review.create(:content => "tweeting!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/places/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(tweet.content)
      end

      it 'does not let a user edit a tweet they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet1 = Review.create(:content => "tweeting!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        tweet2 = Review.create(:content => "look at this tweet", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/places/#{tweet2.id}/edit"
        expect(page.current_path).to include('/places')
      end

      it 'lets a user edit their own tweet if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet = Review.create(:content => "tweeting!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/places/1/edit'

        fill_in(:content, :with => "i love tweeting")

        click_button 'submit'
        expect(Review.find_by(:content => "i love tweeting")).to be_instance_of(Review)
        expect(Review.find_by(:content => "tweeting!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet = Review.create(:content => "tweeting!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/places/1/edit'

        fill_in(:content, :with => "")

        click_button 'submit'
        expect(Review.find_by(:content => "i love tweeting")).to be(nil)
        expect(page.current_path).to eq("/places/1/edit")
      end
    end

    context "logged out" do
      it 'does not load -- requests user to login' do
        get '/places/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own tweet if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet = Review.create(:content => "tweeting!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'places/1'
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:content => "tweeting!")).to eq(nil)
      end

      it 'does not let a user delete a tweet they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet1 = Review.create(:content => "tweeting!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        tweet2 = Review.create(:content => "look at this tweet", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "places/#{tweet2.id}"
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:content => "look at this tweet")).to be_instance_of(Review)
        expect(page.current_path).to include('/places')
      end
    end

    context "logged out" do
      it 'does not load let user delete a tweet if not logged in' do
        tweet = Review.create(:content => "tweeting!", :user_id => 1)
        visit '/places/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
# end