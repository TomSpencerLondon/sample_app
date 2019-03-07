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
        expect(@user.authenticated?('')).to be(false)
      end
    end
  end
end
