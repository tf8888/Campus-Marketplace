require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires email' do
      user = User.new
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'enforces unique email' do
      User.create!(email: 'alice@example.edu', name: 'Alice')
      dup = User.new(email: 'alice@example.edu', name: 'Alice Duplicate')
      expect(dup).to be_invalid
      expect(dup.errors[:email]).to include('has already been taken')
    end
  end

  describe '.from_omniauth' do
    # Uses the shared OmniAuth mock from spec/support/omniauth.rb
    let(:auth_hash) { OmniAuth.config.mock_auth[:google_oauth2] }

    it 'creates a new user when uid not found and sets fields' do
      expect {
        @user = User.from_omniauth(auth_hash)
      }.to change(User, :count).by(1)

      expect(@user).to be_persisted
      expect(@user.uid).to eq('uid-456')
      expect(@user.email).to eq('new@student.edu')
      expect(@user.name).to eq('New Student')
    end

    it 'updates an existing user with same uid and does not duplicate' do
      existing = User.create!(uid: 'uid-456', email: 'old@student.edu', name: 'Old Name')
      expect {
        updated = User.from_omniauth(auth_hash)
        expect(updated.id).to eq(existing.id)
        expect(updated.email).to eq('new@student.edu')
        expect(updated.name).to eq('New Student')
      }.not_to change(User, :count)
    end
  end
end
