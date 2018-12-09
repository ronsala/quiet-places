require_relative "spec_helper"

describe ApplicationController do
  it "signs up" do
    visit('/')
    click_link('Sign Up')
    fill_in('username', :with => 'Capy')
    fill_in('email', :with => 'capy@example.com')
    fill_in('password', :with => '123')
    fill_in('password_confirm', :with => '123')
    click_button('submit')
    expect(page).to have_content('Logged in as Capy')
  end

  # it "creates places" do
  #   visit('/places')
  #   click_link('Create Place')
  #   fill_in('Password', :with => 'Seekrit')
    # [] finish
  # end
end