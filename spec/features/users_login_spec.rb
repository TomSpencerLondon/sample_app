require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do
  include TestPasswordHelper
  scenario 'visit login' do
    visit login_path
    expect(current_path).to eq("/login")
  end

  scenario 'invalid sign in information' do
    FactoryBot.create(:user, password: default_password)
    visit login_path
    fill_in 'session[email]', with: 'tom@spencer.co.uk'
    fill_in 'session[password]', with: ''
    find('input[name="commit"]').click
    expect(current_path).to eq("/login")
    expect(page.body).to include('Invalid email/password combination')
    visit root_path
    expect(page.body).not_to include('Invalid email/password combination')
  end
end
