require_relative "spec_helper"

describe ApplicationController do
  it "signs up" do
    visit('/')
    click_link('Sign Up')
    fill_in('Username', :with => 'Capy')
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