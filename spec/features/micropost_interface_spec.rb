require 'rails_helper'

RSpec.feature "MicropostInterface", type: :feature do

  before(:each) do
    @user = FactoryBot.create(:user,
                              email: 'tom@testing.co.uk',
                              password: 'Password')
    @user_two = FactoryBot.create(:user,
                                  email: 'jim@testers.co.uk',
                                  password: 'Testing123')
    30.times do
      FactoryBot.create(:micropost,
                        content: Faker::Lorem.sentence(5),
                        created_at: 42.days.ago,
                        user: @user)
    end
  end

  scenario 'micropost interface' do
    micropost_count = Micropost.count

    visit login_path
    fill_in 'session[email]', with: 'tom@testing.co.uk'
    fill_in 'session[password]', with: 'Password'
    find('input[name="commit"]').click
    visit root_path
    expect(page.body).to include('<div class="pagination">')

    # Invalid submission
    within "form[action='/microposts']" do
      click_on("Post")
    end
    expect(page.body).to include('<div id="error_explanation">')
    expect(Micropost.count).to eq(micropost_count)    

    #  Valid submission
    within "form[action='/microposts']" do
      fill_in 'micropost[content]', with: 'This is a new post!'
      click_on("Post")
    end
    expect(page.current_path).to eq('/')
    expect(page.body).to include('This is a new post!')
    expect(page.has_link? "delete").to eq(true)
    expect(Micropost.count).to eq(micropost_count + 1)

    # Visit a different user.
    visit user_path(@user_two)
    expect(page.has_link? "delete").to eq(false)
  end
end