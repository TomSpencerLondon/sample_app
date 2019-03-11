require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    user = FactoryBot.create(:user, password: "Password")
    user.activation_token = User.new_token
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.activation_token)
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
