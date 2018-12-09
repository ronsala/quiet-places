require_relative "spec_helper"

describe "UsersController" do

  context "signup" do

    it "signs up a user" do
      visit('/')
      click_link('Sign Up')
      fill_in('username', :with => 'Capy')
      fill_in('email', :with => 'capy@example.com')
      fill_in('password', :with => '123')
      fill_in('password_confirm', :with => '123')
      click_button('submit')
      expect(page).to have_content('Logged in as Capy')
    end

    it "shows an error when no username" do
      visit('/signup')
      fill_in('email', :with => 'noname@example.com')
      fill_in('password', :with => '123')
      fill_in('password_confirm', :with => '123')
      click_button('submit')
      expect(page).to have_content("Username can't be blank. Please try again.")
    end

    it "shows an error when no email" do
      visit('/signup')
      fill_in('username', :with => 'Ofgrid')
      fill_in('password', :with => '123')
      fill_in('password_confirm', :with => '123')
      click_button('submit')
      expect(page).to have_content("Email can't be blank. Please try again.")
    end

    it "shows an error when no password" do
      visit('/signup')
      fill_in('username', :with => 'JC')
      fill_in('email', :with => 'jc@example.com')
      click_button('submit')
      expect(page).to have_content("Password can't be blank. Please try again.")
    end

    it "shows an error when passwords entered don't match" do
      visit('/signup')
      fill_in('username', :with => 'Missy')
      fill_in('email', :with => 'missy@example.com')
      fill_in('password', :with => '123')
      fill_in('password_confirm', :with => '124')
      click_button('submit')
      expect(page).to have_content("Passwords must match. Please try again.")
    end

    it "signs up an admin" do
      visit('/signup')
      fill_in('username', :with => 'Mr. Boss')
      fill_in('email', :with => 'boss@example.com')
      fill_in('password', :with => '123')
      fill_in('password_confirm', :with => '123')
      fill_in('admin_key', :with => ENV["ADMIN_KEY"])
      click_button('submit')
      expect(page).to have_content('Admin account')
    end

    it "shows an error when wrong admin key" do
      visit('/signup')
      fill_in('username', :with => 'Mr. Boss')
      fill_in('email', :with => 'boss@example.com')
      fill_in('password', :with => '123')
      fill_in('password_confirm', :with => '123')
      fill_in('admin_key', :with => "90210")
      click_button('submit')
      expect(page).to have_content('Admin key not recognized. Please try again.')
    end
  end

  context "login" do
    before do
      User.create(:username => 'Happy', :email => 'happy@example.com', :password => 'password')
    end

    it "logs a user in" do
      visit('/login')
      fill_in('username', :with => 'Happy')
      fill_in('password', :with => 'password')
      click_button('submit')
      expect(page).to have_content('Logged in as Happy')
    end

    it "redirects to signup when unsuccessful" do
      visit('/login')
      fill_in('username', :with => 'Sadie')
      fill_in('password', :with => 'password')
      click_button('submit')
      expect(page).to have_current_path('/signup')
    end
  end

  context "logout" do

    it "logs user out and redirects to homepage" do
      visit('/logout')
      expect(page).to have_current_path('/')
    end
  end
end