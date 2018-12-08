require_relative "spec_helper"

describe ApplicationController do
  # pry(RSpec::ExampleGroups::ApplicationController_2)> app
  # => ApplicationController
  it "signs up" do
    visit('/')
    click_link('Sign Up')
    save_and_open_page
    # save_sceenshot('screenshot.png')
    # undefined method `save_sceenshot' for #<RSpec::ExampleGroups::ApplicationController_2:0x007fde72551330>
    # Did you mean?  save_screenshot
    # save_sceenshot
    # undefined local variable or method `save_sceenshot' for #<RSpec::ExampleGroups::ApplicationController_2:0x007fe48ceb1540>
    # Did you mean?  save_screenshot
    # pry(#<RSpec::ExampleGroups::ApplicationController_2>)> current_path
    # => "/signup"
    fill_in('Username * ', :with => 'Capy')
    fill_in('Email', :with => 'capy@example.com')
    fill_in('Password', :with => '123')
    fill_in('Retype Password', :with => '123')
    click_button('Submit')
    expect(page).to have_content('Logged in as Capy')
  end

  # it "creates places" do
  #   visit('/places')
  #   click_link('Create Place')
  #   fill_in('Password', :with => 'Seekrit')
    # [] finish
  # end
end