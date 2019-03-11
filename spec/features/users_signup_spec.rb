require 'rails_helper'

RSpec.feature "UserSignup", type: :feature do
  before do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'visit signup' do
    visit signup_path
    expect(current_path).to eq("/signup")
  end

  scenario 'invalid signup information' do
    visit signup_path
    fill_in 'user[name]', with: '   '
    fill_in 'user[email]', with: 'tom@spencer.co.uk'
    fill_in 'user[password]', with: 'dud'
    fill_in 'user[password_confirmation]', with: 'dud'
    find('input[name="commit"]').click
    expect(page.body).to include('Sign up')
    expect(current_path).to eq("/users")
  end

  scenario 'valid signup information with activation' do
    visit signup_path
    expect(current_path).to eq("/signup")
    fill_in 'user[name]', with: 'Tom Spencer'
    fill_in 'user[email]', with: 'tom@spencer.co.uk'
    fill_in 'user[password]', with: 'Password'
    fill_in 'user[password_confirmation]', with: 'Password'
    find('input[name="commit"]').click
    expect(page.body).to include('Please check your email to activate your account.')
    expect(User.last.activated).to eq(false)
    visit login_path
    fill_in 'session[email]', with: 'tom@spencer.co.uk'
    fill_in 'session[password]', with: 'Password'
    find('input[name="commit"]').click
    expect(current_path).to eq('/')
    expect(page.body).to include('Account not activated. Check your email for the activation link.')
    visit edit_account_activation_path("invalid token", email: User.last.email)
    expect(current_path).to eq('/')
    expect(page.body).to include('Invalid activation link')
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    email_text = ActionMailer::Base.deliveries[0].body.encoded
    email_object = Nokogiri::HTML(email_text)
    site = email_object.at_css("a")[:href]
    visit(site)
    expect(page.body).to include('Account activated!')
    expect(User.last.activated).to eq(true)
  end
end
