require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do

  scenario 'visit signup' do
    visit signup_path
    expect(current_path).to eq("/signup")
  end

  scenario 'invalid signup information' do
    user_count = User.count
    visit signup_path
    fill_in 'user[name]', with: '   '
    fill_in 'user[email]', with: 'tom@spencer.co.uk'
    fill_in 'user[password]', with: 'dud'
    fill_in 'user[password_confirmation]', with: 'dud'
    find('input[name="commit"]').click
    expect(User.count).to eq(user_count)
  end

  scenario 'valid signup information' do
    user_count = User.count
    new_count = user_count + 1
    visit signup_path
    expect(current_path).to eq("/signup")
    fill_in 'user[name]', with: 'Tom Spencer'
    fill_in 'user[email]', with: 'tom@spencer.co.uk'
    fill_in 'user[password]', with: 'Password'
    fill_in 'user[password_confirmation]', with: 'Password'
    find('input[name="commit"]').click
    require 'pry' ; binding.pry
    expect(User.count).to eq(new_count)
  end
end
