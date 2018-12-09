require_relative "spec_helper"

describe 'new action' do
  context 'logged in' do
    before do
      
      users = [
        {username: "Emily", email: "emily@example.org", password: "emilypass"},
        {username: "Felix", email: "felix@example.org", password: "felixpass"},
        {username: "Zoe", email: "zoe@example.org", password: "zoepass"}
      ]
      
      users.each do |x|
        User.create(x)
      end

      places = [
        {user_id: "1", name: "Louie's Breakfast", street: "20 Wabash St.", city: "New Jack City", state: "UT", category: "restaurant", website: "www.louies.com"},
        {user_id: "2", name: "Tavern On the Blue", street: "19 Cookie Monster Way", city: "Hoboken", state: "NJ", category: "bar", website: "www.tonb.com"}, 
        {user_id: "3", name: "Bugsie's Yummies", street: "113 Main Ave", city: "Tampa", state: "FL", category: "restaurant", website: "www.bugsies.com"}
      ]

      places.each do |x|
        Place.create(x)
      end

      visit('/signup')
      fill_in('username', :with => 'Capy')
      fill_in('email', :with => 'capy@example.com')
      fill_in('password', :with => '123')
      fill_in('password_confirm', :with => '123')
      click_button('submit')
    end

    it "responds with a list of places" do
      get '/places'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Louie's Breakfast")
      expect(last_response.body).to include("Bugsie's Yummies")
    end

    it "creates a new place" do
      visit('/places')
      click_link('Create Place')
      fill_in("name", :with => "Larry's Place")
      fill_in("street", :with => "20 Wabash St.")
      fill_in("city", :with => "New Jack City")
      select('Utah', :from=>'state')
      choose('restaurant')
      fill_in("website", :with => "www.larry's.com")
      click_button('submit')
      expect(page).to have_content("Larry's Place")
    end

      it "allows user to edit a place they created" do
        visit("/places/#{current_user.places.last.id}/edit")
        fill_in("name", :with => "Larry's New Place")
        click_button('submit')
        expect(page).to have_content("Larry's New Place")
      end

  end
end