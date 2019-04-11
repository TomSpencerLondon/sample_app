require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = FactoryBot.create(:user,
                              password: 'Password',
                              password_confirmation: 'Password')
    @micropost = FactoryBot.create(:micropost,
                                   content: "Lorem ipsum",
                                   user: @user)
  end

  it 'User is valid' do
    expect(@micropost.valid?).to be(true)
  end

  it 'user id should be present' do
    @micropost.user_id = nil
    expect(@micropost.valid?).to be(false)
  end

  it 'user id should be present' do
    @micropost.content = "    "
    expect(@micropost.valid?).to be(false)
  end

  it 'content should be at most 140 characters' do
    @micropost.content = "a" * 141
    expect(@micropost.valid?).to be(false)
  end

  it 'order should be most recent first' do
    @user = FactoryBot.create(:user,
                              email: 'tom@testers.co.uk',
                              password: 'Testing',
                              password_confirmation: 'Testing')

    FactoryBot.create(:micropost,
                      content: "I just ate an orange!",
                      created_at: 10.minutes.ago,
                      user: @user)
    FactoryBot.create(:micropost,
                      content: "Check out the @tauday site by @mhartle: http://tauday.com",
                      created_at: 3.years.ago,
                      user: @user)
    FactoryBot.create(:micropost,
                      content: 'Sad cats are sad: http://youtu.be/PKffm2uI4dk',
                      created_at: 2.hours.ago,
                      user: @user)
    most_recent_micropost = FactoryBot.create(:micropost,
                                              content: 'Writing a short test',
                                              created_at: Time.zone.now,
                                              user: @user)
    
    expect(Micropost.first).to eq(most_recent_micropost)
  end
end
