require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do

  scenario 'visit signup' do
    visit signup_path
    expect(current_path).to eq("/signup")
  end

  scenario 'invalid signup information' do
    visit signup_path
    fill_in 'user[name]', with: '   '
    fill_in 'user[email]', with: 'tom@spencer.co.uk'
    fill_in 'user[password]', with: 'dud'
    fill_in 'user[password_confirmation]', with: 'dud'
    find('input[name="commit"]').click
    expect(page.body).to include('Sign up')
    expect(current_path).to eq("/users")
  end

  scenario 'valid signup information' do
    visit signup_path
    expect(current_path).to eq("/signup")
    fill_in 'user[name]', with: 'Tom Spencer'
    fill_in 'user[email]', with: 'tom@spencer.co.uk'
    fill_in 'user[password]', with: 'Password'
    fill_in 'user[password_confirmation]', with: 'Password'
    find('input[name="commit"]').click
    expect(page.body).to include('Welcome to the Sample App!')
    find('.dropdown').click
    expect(page.body).to include('Log out')
  end
end
