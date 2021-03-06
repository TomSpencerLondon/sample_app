require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "POST #create" do
    context 'login with invalid information' do
      it "shows a flash message and user login fails" do
        post :create, params: { session: { email: "", password: "" } }
        expect(flash.empty?).to eq(false)
      end
    end

    context 'login with valid information' do
      it "user login succeeds" do
        FactoryBot.create(:user, 
                          name: "Tom Spencer",
                          email: "tom@spencer.com",
                          password: "Testing",
                          password_confirmation: "Testing"
                         )
        post :create, params: { session: { email: "tom@spencer.com", password: "Testing" } }
        expect(flash.empty?).to eq(true)
        expect(session.empty?).to be(false)
        expect(session[:user_id].nil?).to be(false)
      end
    end

    context 'login with valid information followed by logout' do
      it "user login and logout succeed" do
        FactoryBot.create(:user,
                          name: "Tom Spencer",
                          email: "tom@spencer.com",
                          password: "Testing",
                          password_confirmation: "Testing"
                         )
        post :create, params: { session: { email: "tom@spencer.com", password: "Testing" } }
        expect(flash.empty?).to eq(true)
        delete :destroy
        expect(session.empty?).to be(true)
        expect(session[:user_id].nil?).to be(true)
      end
    end

    context 'login with remembering' do
      it "user login and logout succeed" do
        FactoryBot.create(:user,
                          name: "Tom Spencer",
                          email: "tom@spencer.com",
                          password: "Testing",
                          password_confirmation: "Testing"
                         )
        post :create, params: { session: { email: "tom@spencer.com",
                                              password: "Testing",
                                              remember_me: '1' } }
        expect(cookies['remember_token'].present?).to be(true)
      end
    end

    context 'login without remembering' do
      it "user login and logout succeed" do
        FactoryBot.create(:user,
                          name: "Tom Spencer",
                          email: "tom@spencer.com",
                          password: "Testing",
                          password_confirmation: "Testing"
                         )
        post :create, params: { session: { email: "tom@spencer.com",
                                              password: "Testing",
                                              remember_me: '0' } }
        expect(cookies['remember_token'].present?).to be(false)
      end
    end
  end

  describe "SessionHelper" do
    before do
      @user = FactoryBot.create(:user,
                                name: "Michael Spencer",
                                email: "michael@example.com",
                                password_digest: User.digest('password'))
      remember(@user)
    end
    context 'current_user' do
      
      it 'remembers the user returns right user when session is nil' do
        expect(@user).to eq(current_user)
        expect(is_logged_in?).to eq(true)
      end
    end

    context 'current_user' do
      before do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
      end
      
      it 'returns nil when the remember digest is wrong' do
        expect(current_user).to eq(nil)
      end
    end
  end

end
