User.destroy_all
# Users
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

# Microposts
50.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user| 
    FactoryBot.create(:micropost,
                     content: content,
                     user: user)
  end
end

# Following relationships
users = User.all
user = User.first
following = users[2..50]
followers = users[3..40]

following.each do |followed|
  user.follow(followed)
end

followers.each do |follower|
  follower.follow(user)
end