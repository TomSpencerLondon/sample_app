FactoryBot.define do
  factory :micropost do
    content { "MyText" }
    user { user }
  end
end
