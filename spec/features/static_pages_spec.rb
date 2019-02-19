require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do

  before(:each) do
    Capybara.app_host = 'https://shrouded-ravine-12833.herokuapp.com'
  end

  scenario 'visiting the home page' do
    visit '/'
    expect(page).to have_content 'hello, world!'
  end
end
