User.destroy_all

User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "Testing",
             password_confirmation: "Testing",
             admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password
    )
end
