require 'rails_helper'

RSpec.describe User, type: :model do

  context 'saving email addresses' do
    before do
      @mixed_case_email = "FOO@ExAMPle.com"
      @user = User.new(name: "Tom Sparrow", email: @mixed_case_email,
                       password: "foobar", password_confirmation: "foobar")
      @user.save
    end

    it 'email addresses are saved as lower-case' do
      expect(@user.reload.email).to eq(@mixed_case_email.downcase)
    end
  end

  context 'valid user' do
    context 'validates length and presence of name and email' do
      before do
        @user = User.new(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")
      end

      it "User is valid" do
        expect(@user.valid?).to be(true)
      end
    end

    context 'email format' do
      before do
        @valid_addresses = %w[
                             user@example.com USER@foo.COM
                             A_US-ER@foo.bar.org first.last@foo.jp
                             alice+bob@baz.com
                            ]
      end

      it "User is valid" do
        @valid_addresses.each do |valid_address|
          @user = User.new(name: "User Example", email: valid_address,
                           password: "foobar", password_confirmation: "foobar")
          expect(@user.valid?).to be(true)
        end
      end
    end
  end

  context 'when user is destroyed' do
    before do
      @user = FactoryBot.create(:user,
                                email: 'tom@testers.co.uk',
                                password: 'Testing',
                                password_confirmation: 'Testing')
      FactoryBot.create(:micropost,
                        content: 'Lorem Ipsum',
                        created_at: Time.zone.now,
                        user: @user)
    end
    it 'associated microposts are destroyed' do
      expect(Micropost.all.count).to be(2)
      @user.destroy
      expect(Micropost.all.count).to eq(0)
    end
  end

  context 'following and unfollowing users' do
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

    let(:user_three) do
      FactoryBot.create(:user,
                        name: 'Lana',
                        email: 'lana@richardson.co.uk',
                        password: 'Password')
    end

    let(:lana_post_one) do
      FactoryBot.create(:micropost,
                        content: "Hello this is a post by Lana",
                        user: user_three)
    end

    let(:lana_post_two) do
      FactoryBot.create(:micropost,
                        content: "Hello this is a second post by Lana",
                        user: user_three)
    end

    let(:archer_post) do
      FactoryBot.create(:micropost,
                        content: "This is my archer post not yours",
                        user: user_two)
    end

    it 'feed should have the right posts' do
      user.follow(user_three)
      # Posts from followed user
      user_three.microposts.each do |post_following|
        expect(user.feed).to include(post_following)
      end
      # Posts from self
      user.microposts.each do |post_self|
        expect(user.feed).to include(post_self)
      end
      # Posts from unfollowed user
      user_two.microposts.each do |post_unfollowed|
        expect(user.feed).not_to include(post_unfollowed) 
      end
    end

    it 'should not follow unless selected' do
      expect(user.following?(user_two)).to eq(false)
    end

    it 'should follow when selected' do
      user.follow(user_two)
      expect(user.following?(user_two)).to eq(true)
    end

    it 'should unfollow when selected' do
      user.follow(user_two)
      expect(user.following?(user_two)).to eq(true)
      expect(user_two.followers).to include(user)
      user.unfollow(user_two)
      expect(user.following?(user_two)).to eq(false)
    end
  end

  context 'invalid user' do
    context 'missing name' do
      before do
        @user = User.new(name: "   ", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")
      end

      it "User invalid - missing name" do
        expect(@user.valid?).to be(false)
      end
    end

    context 'missing email' do
      before do
        @user = User.new(name: "John Spicer", email: "    ",
                         password: "foobar", password_confirmation: "foobar")
      end

      it "User invalid - missing name" do
        expect(@user.valid?).to be(false)
      end
    end

    context 'name is too long' do
      before do
        long_name = "a" * 51
        @user = User.new(name: long_name, email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")
      end

      it "User invalid - name is too long" do
        expect(@user.valid?).to be(false)
      end
    end

    context 'email is too long' do
      before do
        long_email = "a" * 256
        @user = User.new(name: "John Williams", email: long_email)
      end

      it "User invalid - email is too long" do
        expect(@user.valid?).to be(false)
      end
    end

    context 'wrong email format' do
      before do
        @invalid_addresses = %w[
                             user@example,com USER_at_foo.org 
                             user.name@example. foo@bar_baz.com
                             foo+baz.com
                            ]
      end

      it "User is invalid - wrong email format" do
        @invalid_addresses.each do |invalid_address|
          @user = User.new(name: "User Example", email: invalid_address,
                           password: "foobar", password_confirmation: "foobar") 
          expect(@user.valid?).to be(false)
        end
      end
    end

    context 'email address is not unique' do
      before do
        @user = User.new(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")
        @user.save       
      end

      it "User is invalid - wrong email format" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        expect(duplicate_user.valid?).to be(false)
      end
    end

    context 'password is too short' do
      before do
        password = "a" * 5
        @user = User.new(name: "Example User", email: "user@example.com",
                         password: password, password_confirmation: password)     
      end

      it "User is invalid - password too short" do
        expect(@user.valid?).to be(false)
      end
    end

    context 'authenticated? returns false for a user with nil digest' do
      before do
        password = "password"
        @user = User.new(name: "Example User", email: "user@example.com",
          password: password, password_confirmation: password)
      end
      it 'returns false' do
        expect(@user.authenticated?(:remember, '')).to be(false)
      end
    end
  end
end
