require 'rails_helper'

RSpec.feature "UsersProfile", type: :feature do
  include ApplicationHelper

  before do
    @user = FactoryBot.create(:user,
                              name: "Michael Jones",
                              email: "michael@jones.co.uk",
                              password: "Password"
                              )
    30.times do
      FactoryBot.create(:micropost,
                        content: Faker::Lorem.sentence(5),
                        created_at: 42.days.ago,
                        user: @user)
    end
  end

  it 'profile display' do
    visit user_path(@user)
    expect(page.title).to eq(full_title(@user.name))
    expect(page.find('h1').text()).to eq(@user.name)
    h_one = page.find('h1')
    expect(h_one.find('img')[:class]).to eq("gravatar")
    expect(page.body).to include(@user.microposts.count.to_s)
    expect(page.body).to include('<div class="pagination">')
    @user.microposts.paginate(page: 1).each do |micropost|
      expect(page.body).to include(micropost.content)
    end
  end

end