require_relative "spec_helper"

describe "UsersController" do
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


end