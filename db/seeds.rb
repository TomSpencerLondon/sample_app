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
