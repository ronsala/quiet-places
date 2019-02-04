# First section of tests adapted from Flatiron School's Fwitter spec:

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


  describe 'user show page' do
    it "shows all a single user's places" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      place = Place.create(user_id: "1", name: "Louie's Breakfast", street: "20 Wabash St.", city: "New Jack City", state: "UT", category: "restaurant", website: "www.example.com")
      place2 = Place.create(user_id: "1", name: "The Other Place", street: "20 Division St", city: "Phoenix", state: "AZ", category: "bar", website: "www.example.com")

      visit "/users/1"

      expect(page.current_path).to eq("/users/1")
      expect(page).to have_content("The Other Place")
      expect(page).to have_content("New Jack City")
    end
  end

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

        visit '/reviews/new'

        fill_in(:title, :with => "This is my review")
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

        visit '/reviews/new'

        fill_in(:title, :with => "My blank review")
        fill_in(:body, :with => "")
        click_button 'submit'

        expect(Review.find_by(:body => "")).to eq(nil)
        expect(page.current_path).to eq("/reviews/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new review form if not logged in' do
        visit '/logout'
        get '/places/new'
        expect(page.current_path).to eq('/')
      end
    end
  end

  describe 'show action' do

    context 'logged in' do

      it 'displays a single review' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:title => "Boss Review", :body => "i am a boss at reviewing", :user_id => user.id)
        place = Place.create(user_id: "1", name: "Louie's Breakfast", street: "20 Wabash St.", city: "New Jack City", state: "UT", category: "restaurant", website: "www.louies.com")
        visit "/reviews/1"
        expect(page.body).to include("Boss Review")
        expect(page.body).to include("New Jack City")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view review edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review = Review.create(:title => "Another great review", :body => "reviewing!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/reviews/1/edit'
        expect(page.body).to include(review.body)
      end

      it 'does not let a user edit a review they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        review1 = Review.create(:title => "Another great review", :body => "reviewing!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        review2 = Review.create(:title => "An even better review", :body => "look at this review", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/places/#{review2.id}/edit"
        expect(page.current_path).to include('/places')
      end

      it 'lets a user edit their own review if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        place = Place.create(user_id: "1", name: "Louie's Breakfast", street: "20 Wabash St.", city: "New Jack City", state: "UT", category: "restaurant", website: "www.louies.com")
        review = Review.create(:title => "Another great review", :body => "reviewing!", :user_id => 1, :place_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button('submit')
        visit '/reviews/1/edit'
        fill_in(:body, :with => "i love reviewing")

        click_button('Submit')
        expect(Review.find_by(:body => "i love reviewing")).to be_instance_of(Review)
        expect(Review.find_by(:body => "reviewing!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end
    end

    context "logged out" do
      it 'does not load -- redirects to homepage' do
        get '/reviews/1/edit'
        expect(last_response.location).to include("/")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own review if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        place = Place.create(user_id: "1", name: "Louie's Breakfast", street: "20 Wabash St.", city: "New Jack City", state: "UT", category: "restaurant", website: "www.louies.com")
        review = Review.create(:title => "Another great review", :body => "reviewing!", :user_id => 1, :place_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button('submit')
        visit 'reviews/1'
        click_link("Delete")
        expect(page.status_code).to eq(200)
        expect(Review.find_by(:body => "reviewing!")).to eq(nil)
      end
    end
  end

  # Tests from scratch:

  describe 'Admin functions' do
    it 'with correct key can sign up as an admin' do


      visit('/signup')
      fill_in('username', :with => 'True Admin')
      fill_in('email', :with => 'true@example.com')
      fill_in('password', :with => 'adminspassword')
      fill_in('password_confirm', :with => 'adminspassword')
      fill_in('admin_key', :with => '149162')
      click_button('submit')
      # follow_redirect!
      expect(page.current_path).to eq('/places')
      expect(page).to have_content("Admin account")
    end

    # it 'with incorrect key cannot sign up as an admin' do
      
    # end

    # it 'can delete review by other user' do
    #   user = User.create(:username => "spammer", :email => "spam@example.com", :password => "garbage")
    #   review1 = Review.create(:title => "Total %$#&!}", :body => "Nastiness!", :user_id => user.id)

    # visit('/signup')
    # fill_in('username', :with => 'True Admin')
    # fill_in('email', :with => 'true@example.com')
    # fill_in('password', :with => 'adminspassword')
    # fill_in('password_confirm', :with => 'adminspassword')
    # fill_in('admin_key', :with => '149162')
    # click_button('submit')

    # visit('/reviews/1')

    # review = Review.find_by(:body => "Nastiness!")
    # expect(review).to be_nil
    # end

  end