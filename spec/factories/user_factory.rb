FactoryBot.define do
  factory :user, class: 'User' do

    name { "Tom Spencer" }
    email { "tom@spencer.co.uk" }
    activated { true }
    activated_at { Time.zone.now }
  end
end