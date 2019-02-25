require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do

  scenario 'visit login' do
    visit login_path
    expect(current_path).to eq("/login")
  end

  context 'user sign in' do
    before(:each) do
      User.create(
        name: "Tom Spencer",
        email: "tom@spencer.co.uk",
        password: "Testing",
        password_confirmation: "Testing"
        )
      visit login_path
    end

    scenario 'invalid sign in information' do
      fill_in 'session[email]', with: 'tom@spencer.co.uk'
      fill_in 'session[password]', with: ''
      find('input[name="commit"]').click
      expect(current_path).to eq("/login")
      expect(page.body).to include('Invalid email/password combination')
      visit root_path
      expect(page.body).not_to include('Invalid email/password combination')
    end

    scenario 'valid sign in information' do
      fill_in 'session[email]', with: 'tom@spencer.co.uk'
      fill_in 'session[password]', with: 'Testing'
      find('input[name="commit"]').click
      expect(current_path).to eq('/users/1')
      expect(page.body).not_to include('Log in')
      expect(page.body).to include('Log out')
    end

    scenario 'valid sign in information followed by logout' do
      fill_in 'session[email]', with: 'tom@spencer.co.uk'
      fill_in 'session[password]', with: 'Testing'
      find('input[name="commit"]').click
      expect(current_path).to eq('/users/1')
      expect(page.body).not_to include('Log in')
      expect(page.body).to include('Log out')
      find('.dropdown').click
      find('a[href="/logout"]').click
      expect(page.body).to include('Welcome to the Sample App')
    end
  end
end
