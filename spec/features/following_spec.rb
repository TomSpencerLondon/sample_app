require 'rails_helper'

RSpec.feature "Following", type: :feature do
  before do
    @user = FactoryBot.create(:user,
                              email: 'tom@testing.co.uk',
                              password: 'Password')
    FactoryBot.create(:relationship,
                      follower_id: 1,
                      followed_id: @user.id)
  end

  describe 'page' do
    it 'shows following' do
      visit login_path
      fill_in 'session[email]', with: 'tom@testing.co.uk'
      fill_in 'session[password]', with: 'Password'
      find('input[name="commit"]').click
      visit following_user_path(@user)
      expect(@user.following.empty?).to eq(false)
      expect(page.body).to include(@user.following.count.to_s)
      @user.following.each do |user|
        expect(page).to have_link(href: user_path(user))
      end
    end
  end

  describe 'page' do
    it 'shows followers' do
      visit login_path
      fill_in 'session[email]', with: 'tom@testing.co.uk'
      fill_in 'session[password]', with: 'Password'
      find('input[name="commit"]').click
      visit followers_user_path(@user)
      expect(@user.following.empty?).to eq(false)
      expect(page.body).to include(@user.followers.count.to_s)
      @user.followers.each do |user|
        expect(page).to have_link(href: user_path(user))
      end
    end
  end
end
