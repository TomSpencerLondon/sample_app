require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
  let(:user) { FactoryBot.create(:user, password: "password", activated: false) }
  describe "GET #edit" do
    context 'activation token and correct email' do
      it "activates the user" do
        get :edit, params: {id: user.activation_token, email: user.email}
        expect(user.reload.activated?).to eq(true)
      end
    end

    context 'activation token and incorrect email' do
      it "fails to activate user" do
        get :edit, params: {id: user.activation_token, email: "incorrect@email.com"}
        expect(user.reload.activated?).to eq(false)
      end
    end

    context 'incorrect activation token and correct email' do
      it "fails to activate user" do
        get :edit, params: {id: "Incorrect Token", email: user.email}
        expect(user.reload.activated?).to eq(false)
      end
    end
  end
end
