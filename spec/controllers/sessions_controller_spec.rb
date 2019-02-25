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
        User.create(name: "Tom Spencer",
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
        User.create(name: "Tom Spencer",
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
  end

end
