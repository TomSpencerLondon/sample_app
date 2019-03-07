require 'rails_helper'

RSpec.feature "UsersEdit", type: :feature do
  include TestPasswordHelper

  before do
    @user = FactoryBot.create(:user, password: default_password)
  end

  scenario 'unsuccessful edit' do
    visit login_path
    fill_in 'session[email]', with: 'tom@spencer.co.uk'
    fill_in 'session[password]', with: default_password
    find('input[name="commit"]').click
    visit edit_user_path(@user)
    fill_in 'user[name]', with: ''
    fill_in 'user[email]', with: 'false@email.com'
    fill_in 'user[password]', with: 'Password'
    fill_in 'user[password_confirmation]', with: 'Password'
    find('input[name="commit"]').click
    expect(current_path).to eq('/users/1')
    expect(page.body).to include("Name can&#39;t be blank")
  end

  scenario 'successful edit' do
    visit login_path
    fill_in 'session[email]', with: 'tom@spencer.co.uk'
    fill_in 'session[password]', with: default_password
    find('input[name="commit"]').click
    visit edit_user_path(@user)
    name = 'John Williams'
    email = 'john@spencer.co.uk'
    fill_in 'user[name]', with: name
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: ''
    fill_in 'user[password_confirmation]', with: ''
    find('input[name="commit"]').click
    expect(current_path).to eq('/users/1')
    expect(page.body).to include('Profile updated')
    @user.reload
    expect(@user.name).to eq(name)
    expect(@user.email).to eq(email)
  end
end
