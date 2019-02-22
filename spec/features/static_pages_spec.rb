require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do

  before(:each) do
    Capybara.app_host = 'https://shrouded-ravine-12833.herokuapp.com'
  end

  scenario 'visiting the home page' do
    visit root_path
    expect(current_path).to eq("/")
    expect(page).to have_content 'Welcome to the Sample App'
  end

  scenario 'clicking the logo' do
    visit root_path
    page.find('#logo').click
    expect(current_path).to eq("/")
    expect(page).to have_content 'Welcome to the Sample App'
  end

  scenario 'clicking help in the navbar' do
    visit root_path
    find('a[href="/help"]').click
    expect(page).to have_content 'Help'
  end

  scenario 'clicking about in the footer' do
    visit root_path
    find('a[href="/about"]').click
    expect(page).to have_content 'About'
  end

  scenario 'clicking contact in the footer' do
    visit root_path
    find('a[href="/contact"]').click
    expect(page).to have_content 'Contact'
  end

  scenario 'clicking sign up in the footer' do
    visit root_path
    find('a[href="/signup"]').click
    expect(page).to have_content 'Sign up'
  end
end
