FactoryBot.define do
  factory :user, class: 'User' do

    name { "Tom Spencer" }
    email { "tom@spencer.co.uk" }
    activated { true }
    activated_at { Time.zone.now }

    after :create do |user|
      create :micropost, user: user
    end
  end
end