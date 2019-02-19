require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home" do
    it "returns home page" do
      get :home
      expect(response).to have_http_status(:success)
      assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
    end
  end

  describe "GET #help" do
    it "returns help page" do
      get :help
      expect(response).to have_http_status(:success)
      assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
    end
  end

  describe "GET #about" do
    it "returns about page" do
      get :about
      expect(response).to have_http_status(:success)
      assert_select "title", "About | Ruby on Rails Tutorial Sample App"
    end
  end
end
