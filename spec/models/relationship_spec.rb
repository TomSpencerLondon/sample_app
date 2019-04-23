require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) do 
    FactoryBot.create(:user)
  end

  let(:user_two) do
    FactoryBot.create(:user,
                      name: "Harry Adams",
                      email: "harry@adams.co.uk",
                      password: "Testering123"
                     )
  end

  let(:subject) do
    described_class.new(follower_id: user.id, followed_id: user_two.id)
  end
  
  it 'should be valid' do
    expect(subject.valid?).to eq(true)
  end

  context 'when there is no follower_id' do
    let(:subject) do
      described_class.new(follower_id: user.id, followed_id: nil)
    end

    it 'relationship should fail' do
      expect(subject.valid?).to eq(false)
    end
  end

  context 'when there is no followed_id' do
    let(:subject) do
      described_class.new(follower_id: nil, followed_id: user_two.id)
    end

    it 'relationship should fail' do
      expect(subject.valid?).to eq(false)
    end
  end
end
