require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do

  before do
    @user = FactoryBot.create(:user,
                              email: 'tom@testing.co.uk',
                              password: 'Password')
    @micropost = FactoryBot.create(:micropost,
                                   content: "Lorem Ipsum",
                                   user: @user)
    @user_two = FactoryBot.create(:user,
                                  name: "Terry Hanson",
                                  email: "terry@hanson.co.uk",
                                  password: 'Testing123')
    @micropost_user_two = FactoryBot.create(:micropost,
                                            content: "This is Terry's micropost",
                                            user: @user_two)
    @count = Micropost.count
  end

  it 'should redirect create when not logged in' do
    post :create, params: { micropost: {content: "Lorem Ipsum" } }
    expect(Micropost.count).to eq(@count)
    expect(response).to redirect_to(login_url)
  end

  it 'should redirect destroy when not logged in' do
    delete :destroy, params: { id: @micropost }
    expect(response).to redirect_to(login_url)
  end

  it 'should redirect destroy for wrong micropost' do
    log_in_as(@user)
    delete :destroy, params: { id: @micropost_user_two }
    expect(Micropost.count).to eq(@count)
  end

  it 'should delete a micropost when the user is correct' do
    log_in_as(@user)
    post :destroy, params: { id: @micropost }
    expect(Micropost.count).to eq(@count - 1)
  end
end
