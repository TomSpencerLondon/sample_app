require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    context 'when not logged in' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "POST #create" do
    context 'Non admin user' do
      it 'is unable to set themselves as admin' do
        post :create, params: { user: {
                                        name: "Tim James",
                                        email: "tim@james.co.uk",
                                        password: "Testing",
                                        password_confirmation: "Testing",
                                        admin: true
                                      }
                              }
        expect(User.first.admin?).to eq(false)
      end
    end

    context 'sign up with invalid information' do
      it "session is empty and user is not added to database" do
        user_count = User.count
        post :create, params: { user: {
                                        name: "Tom Spencer",
                                        email: "tom@homeflowing.co.uk",
                                        password: "",
                                        password_confirmation: ""
                                      }
                              }
        expect(User.count).to eq(user_count)
        expect(session.empty?).to be(true)
      end
    end

    context 'sign up with valid information' do
      it "session is filled and user is added to database" do
        user_count = User.count
        new_count = user_count + 1
        post :create, params: { user: {
                                        name: "Tom Spencer",
                                        email: "tom@homeflowing.co.uk",
                                        password: "testing",
                                        password_confirmation: "testing"
                                      }
                              }
        expect(User.count).to eq(new_count)
        expect(session.empty?).to be(false)
        expect(session[:user_id].nil?).to be(false)
      end
    end

    context 'sign up with valid information followed by signout' do
      it "session is filled and user is added to database" do
        user_count = User.count
        new_count = user_count + 1
        post :create, params: { user: {
                                        name: "Tom Spencer",
                                        email: "tom@homeflowing.co.uk",
                                        password: "testing",
                                        password_confirmation: "testing"
                                      }
                              }
        expect(User.count).to eq(new_count)
        expect(session.empty?).to be(false)
        expect(session[:user_id].nil?).to be(false)
      end
    end
  end
  describe "POST #edit" do
    context 'edit page when user is not logged in' do
      before do
        @user = FactoryBot.create(:user, password: default_password)
      end

      it 'redirects edit when not logged in' do
        get :edit, params: { id: @user }
        expect(flash.empty?).to eq(false)
        expect(response).to redirect_to(login_url)
      end
    end

    context 'update page when user is not logged in' do
      before do
        @user = FactoryBot.create(:user, password: default_password)
      end

      it 'redirects update when not logged in' do
        patch :update, params: { id: @user }
        expect(flash.empty?).to eq(false)
        expect(response).to redirect_to(login_url)
      end
    end

    context 'edit page when logged into wrong user' do
      before do
        @user       = FactoryBot.create(:user, password: default_password)
        @other_user = FactoryBot.create(:user, name: "Jim Davidson",
                                               email: "jim@email.com",
                                               password: "Testing")
      end

      it 'redirects edit when not logged in' do
        log_in_as(@other_user)
        get :edit, params: { id: @user }
        expect(flash.empty?).to eq(true)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'update page when logged into wrong user' do
      before do
        @user       = FactoryBot.create(:user, password: default_password)
        @other_user = FactoryBot.create(:user, name: "Jim Davidson",
                                               email: "jim@email.com",
                                               password: "Testing")
      end

      it 'redirects update when not logged in' do
        log_in_as(@other_user)
        patch :update, params: { id: @user }
        expect(flash.empty?).to eq(true)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST #destroy" do
    context 'when not logged in' do
      before do
        @user = FactoryBot.create(:user, password: default_password, admin: true)
      end

      it 'redirects to login' do
        user_count = User.count
        delete :destroy, params: { id: @user }
        expect(User.count).to eq(user_count)
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when logged in' do
      before do
        @user = FactoryBot.create(:user, password: default_password, admin: false)
      end
      
      it 'redirects to root url' do
        log_in_as(@user)
        user_count = User.count
        delete :destroy, params: { id: @user }
        expect(User.count).to eq(user_count)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
