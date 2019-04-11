require 'factory_bot'
FactoryBot.find_definitions

User.destroy_all

FactoryBot.create(:user,
                  name: "Example User",
                  email: "example@railstutorial.org",
                  password: "Testing",
                  password_confirmation: "Testing",
                  admin: true,
                  activated: true,
                  activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  FactoryBot.create(:user,
                    name: name,
                    email: email,
                    password: password,
                    password_confirmation: password,
                    activated: true,
                    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)

50.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user| 
    FactoryBot.create(:micropost,
                     content: content,
                     user: user)
  end
end
