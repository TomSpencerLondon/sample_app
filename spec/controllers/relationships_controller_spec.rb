require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) do
    FactoryBot.create(:user)
  end

  let(:user_two) do
    FactoryBot.create(:user,
                      name: 'Archer Adams',
                      email: 'archer@adams.co.uk',
                      password: 'Testing'
                      )
  end
  
  let(:relationship) do
    FactoryBot.create(:relationship,
                      follower_id: user.id,
                      followed_id: user_two.id)
  end

  let(:user_three) do
    FactoryBot.create(:user,
                      name: 'Tim Jones',
                      email: 'tim@jones.co.uk',
                      password: 'Password')
  end

  it 'create should require logged-in user' do
    post :create, params: { followed_id: user_three.id }
    expect(response).to redirect_to(login_url)
  end

  it 'destroy should require a logged-in user' do
    delete :destroy, params: { id: relationship.id }
    expect(response).to redirect_to(login_url)
  end
end
