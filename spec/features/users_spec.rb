require 'rails_helper'

RSpec.feature "Users", type: :feature do

  # before(:each) do
  #   Capybara.app_host = 'https://shrouded-ravine-12833.herokuapp.com'
  # end

  scenario 'visiting the home page' do
    visit root_path
    expect(current_path).to eq("/")
    expect(page).to have_content 'Welcome to the Sample App'
  end
end
