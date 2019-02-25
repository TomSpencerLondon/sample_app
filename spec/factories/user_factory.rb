FactoryBot.define do
  factory :user, class: 'User' do

    name { "Tom Spencer" }
    email { "tom@spencer.co.uk" }
  end
end