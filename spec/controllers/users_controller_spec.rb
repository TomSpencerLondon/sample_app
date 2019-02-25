require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #create" do
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
end
