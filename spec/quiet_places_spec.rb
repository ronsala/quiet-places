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

    before(:each) do
      get '/logout'
    end

    it 'loads the signup page' do
      visit('/')
      click_link('Sign Up')
      expect(page).to have_content("Have an admin key?")
    end

    it 'signup directs user to places index' do
      visit('/signup')
      fill_in('username', :with => 'skittles123')
      fill_in('email', :with => 'skittles@aol.com')
      fill_in('password', :with => 'rainbows')
      fill_in('password_confirm', :with => 'rainbows')
      click_button('submit')
      follow_redirect!
      expect(page.current_path).to eq('/places')
    end

    it 'does not let a user sign up without a username' do
      visit('/signup')
      fill_in('username', :with => '')
      fill_in('email', :with => 'skittles@aol.com')
      fill_in('password', :with => 'rainbows')
      fill_in('password_confirm', :with => 'rainbows')
      click_button('submit')
      follow_redirect!
      expect(page.current_path).to eq('/signup')
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
      get '/logout'
      follow_redirect!
      expect(last_response.body).to include("Log In")
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

  # [] fix 
  # describe 'user show page' do
  #   it "shows all a single user's places" do
  #     user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #     place1 = Place.create(:name => "The Best Place", :street => "20 Hope St", :city => "Boston, MA", :user_id => user.id)
  #     place2 = Place.create(:name => "The Other Place", :street => "20 Division St", :city => "Phoenix, AZ", :user_id => user.id)
  #     get "/users/#{user.id}"

  #     expect(last_response.location).to include('/users/#{user.id}')
  #     expect(last_response.body).to include("The Other Place")
  #     expect(last_response.body).to include("Boston, MA")

  #   end
  # end

  describe 'Reviews index action' do
    context 'logged in' do
      it 'lets a user view the reviews index if logged in' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review1 = Review.create(:title => "Review 1 title", :body => "reviewing!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        review2 = Review.create(:title => "Review 2 title", :body => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/reviews"
        expect(page.body).to include(review1.title)
        expect(page.body).to include(review2.title)
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new review form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/reviews/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a review if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        place = Place.create(user_id: "1", name: "Louie's Breakfast", street: "20 Wabash St.", city: "New Jack City", state: "UT", category: "restaurant", website: "www.louies.com")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/reviews/new'
        check("Louie's Breakfast")
        fill_in(:title, :with => "This is my review")
        fill_in(:body, :with => "review!!!")
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        review = Review.find_by(:body => "review!!!")
        expect(review).to be_instance_of(Review)
        expect(review.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user review from another user' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/places/new'

        fill_in(:body, :with => "review!!!")
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        review = Review.find_by(:body => "review!!!")
        expect(review).to be_instance_of(Review)
        expect(review.user_id).to eq(user.id)
        expect(review.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank review' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/places/new'

        fill_in(:body, :with => "")
        click_button 'submit'

        expect(Review.find_by(:body => "")).to eq(nil)
        expect(page.current_path).to eq("/places/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new review form if not logged in' do
        get '/places/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single review' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:body => "i am a boss at reviewing", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/places/#{review.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Review")
        expect(page.body).to include(review.body)
        expect(page.body).to include("Edit Review")
      end
    end

    context 'logged out' do
      it 'does not let a user view a review' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:body => "i am a boss at reviewing", :user_id => user.id)
        get "/places/#{review.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view review edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:body => "reviewing!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/places/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(review.body)
      end

      it 'does not let a user edit a review they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review1 = Review.create(:body => "reviewing!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        review2 = Review.create(:body => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/places/#{review2.id}/edit"
        expect(page.current_path).to include('/places')
      end

      it 'lets a user edit their own review if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:body => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/places/1/edit'

        fill_in(:body, :with => "i love reviewing")

        click_button 'submit'
        expect(Review.find_by(:body => "i love reviewing")).to be_instance_of(Review)
        expect(Review.find_by(:body => "reviewing!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank body' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:body => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/places/1/edit'

        fill_in(:body, :with => "")

        click_button 'submit'
        expect(Review.find_by(:body => "i love reviewing")).to be(nil)
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
      it 'lets a user delete their own review if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:body => "reviewing!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'places/1'
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:body => "reviewing!")).to eq(nil)
      end

      it 'does not let a user delete a review they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review1 = Review.create(:body => "reviewing!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        review2 = Review.create(:body => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "places/#{review2.id}"
        click_button "Delete Review"
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:body => "look at this review")).to be_instance_of(Review)
        expect(page.current_path).to include('/places')
      end
    end

    context "logged out" do
      it 'does not load let user delete a review if not logged in' do
        review = Review.create(:body => "reviewing!", :user_id => 1)
        visit '/places/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
# end