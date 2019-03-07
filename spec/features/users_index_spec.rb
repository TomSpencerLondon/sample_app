require 'rails_helper'

RSpec.feature "UsersIndex", type: :feature do
  before do
    @admin = FactoryBot.create(:user, password: default_password, admin: true)
    @non_admin = FactoryBot.create(:user, name: "Tim Jones", email: "tim@jones.co.uk", password: "Password")
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      FactoryBot.create(:user,
                        name: name,
                        email: email,
                        password: password,
                        password_confirmation: password)
    end
    
  end

  scenario 'index as admin including pagination and delete links' do
    visit login_path
    fill_in 'session[email]', with: 'tom@spencer.co.uk'
    fill_in 'session[password]', with: default_password
    find('input[name="commit"]').click
    visit users_path
    expect(page.body).to include('<div class="pagination">')
    expect(page.body).to include('<a href="/users/1">')
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      expect(page).to have_link(href: user_path(user), text: user.name)
      unless user == @admin
        expect(page).to have_link(href: user_path(user), text: 'delete')
      end
    end
  end

  scenario 'index as non-admin including pagination and delete links' do
    visit login_path
    fill_in 'session[email]', with: 'tim@jones.co.uk'
    fill_in 'session[password]', with: "Password"
    find('input[name="commit"]').click
    visit users_path
    expect(page.body).to include('<div class="pagination">')
    expect(page.body).to include('<a href="/users/1">')
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      expect(page).to have_link(href: user_path(user), text: user.name)
      expect(page).not_to have_link(href: user_path(user), text: 'delete')
    end
  end
end
