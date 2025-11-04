require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:owner) { User.create!(name: "Owner", email: "owner@example.com", role: "member", verified: true) }
  let(:requester) { User.create!(name: "Requester", email: "requester@example.com", role: "member", verified: true) }
  let(:category) { Category.create!(name: "Electronics") }
  let(:item) { Item.create!(title: "Test Item", user: owner, category: category, for_sale: true, price: 100, available: true, condition: "New") }

  describe 'associations' do
    it { should belong_to(:item) }
    it { should belong_to(:user) }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_one(:rating).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[pending approved rejected]) }
    it { should validate_length_of(:message).is_at_most(1000) }
  end

  describe 'database columns' do
    it { should have_db_column(:item_id).of_type(:integer) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:status).of_type(:string) }
    it { should have_db_column(:message).of_type(:text) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'user_cannot_request_own_item validation' do
    it 'is valid when user is not the item owner' do
      request = Request.new(
        item: item,
        user: requester,
        status: "pending",
        message: "I want this"
      )
      expect(request).to be_valid
    end

    it 'is invalid when user tries to request their own item' do
      request = Request.new(
        item: item,
        user: owner,
        status: "pending",
        message: "I want my own item"
      )
      expect(request).not_to be_valid
      expect(request.errors[:user_id]).to include("cannot request their own item")
    end
  end

  describe 'status validation' do
    it 'is valid with status "pending"' do
      request = Request.new(item: item, user: requester, status: "pending")
      expect(request).to be_valid
    end

    it 'is valid with status "approved"' do
      request = Request.new(item: item, user: requester, status: "approved")
      expect(request).to be_valid
    end

    it 'is valid with status "rejected"' do
      request = Request.new(item: item, user: requester, status: "rejected")
      expect(request).to be_valid
    end

    it 'is invalid with invalid status' do
      request = Request.new(item: item, user: requester, status: "invalid_status")
      expect(request).not_to be_valid
      expect(request.errors[:status]).to include("is not included in the list")
    end
  end

  describe 'message validation' do
    it 'is valid without a message' do
      request = Request.new(item: item, user: requester, status: "pending")
      expect(request).to be_valid
    end

    it 'is invalid with message longer than 1000 characters' do
      request = Request.new(
        item: item,
        user: requester,
        status: "pending",
        message: "a" * 1001
      )
      expect(request).not_to be_valid
      expect(request.errors[:message]).to include("is too long (maximum is 1000 characters)")
    end

    it 'is valid with message exactly 1000 characters' do
      request = Request.new(
        item: item,
        user: requester,
        status: "pending",
        message: "a" * 1000
      )
      expect(request).to be_valid
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated messages when request is destroyed' do
      request = Request.create!(item: item, user: requester, status: "pending", message: "I want this")
      Message.create!(request: request, sender: requester, receiver: owner, content: "Hello")
      
      expect { request.destroy }.to change { Message.count }.by(-1)
    end

    it 'destroys associated rating when request is destroyed' do
      request = Request.create!(item: item, user: requester, status: "approved", message: "I want this")
      Rating.create!(rater: requester, ratee: owner, request: request, score: 9)
      
      expect { request.destroy }.to change { Rating.count }.by(-1)
    end
  end

  describe 'factory' do
    it 'creates a valid request' do
      request = Request.create!(
        item: item,
        user: requester,
        status: "pending",
        message: "Test request"
      )
      expect(request).to be_persisted
      expect(request.status).to eq("pending")
    end
  end
end
