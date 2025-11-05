require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:sender) { User.create!(name: "Sender", email: "sender@example.com", role: "member", verified: true) }
  let(:receiver) { User.create!(name: "Receiver", email: "receiver@example.com", role: "member", verified: true) }
  let(:category) { Category.create!(name: "Electronics") }
  let(:item) { Item.create!(title: "Test Item", user: receiver, category: category, for_sale: true, price: 100, available: true, condition: "New") }
  let(:request) { Request.create!(item: item, user: sender, status: "pending", message: "I want this") }

  describe 'associations' do
    it { should belong_to(:request) }
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:receiver).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(500) }
  end

  describe 'database columns' do
    it { should have_db_column(:content).of_type(:text) }
    it { should have_db_column(:request_id).of_type(:integer) }
    it { should have_db_column(:sender_id).of_type(:integer) }
    it { should have_db_column(:receiver_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'sender_and_receiver_cannot_be_the_same validation' do
    it 'is valid when sender and receiver are different users' do
      message = Message.new(
        request: request,
        sender: sender,
        receiver: receiver,
        content: "Hello"
      )
      expect(message).to be_valid
    end

    it 'is invalid when sender and receiver are the same user' do
      message = Message.new(
        request: request,
        sender: sender,
        receiver: sender,
        content: "Hello to myself"
      )
      expect(message).not_to be_valid
      expect(message.errors[:receiver]).to include("can't be the same as sender")
    end
  end

  describe 'content validation' do
    it 'is invalid without content' do
      message = Message.new(
        request: request,
        sender: sender,
        receiver: receiver
      )
      expect(message).not_to be_valid
      expect(message.errors[:content]).to include("can't be blank")
    end

    it 'is invalid with content longer than 500 characters' do
      message = Message.new(
        request: request,
        sender: sender,
        receiver: receiver,
        content: "a" * 501
      )
      expect(message).not_to be_valid
      expect(message.errors[:content]).to include("is too long (maximum is 500 characters)")
    end

    it 'is valid with content exactly 500 characters' do
      message = Message.new(
        request: request,
        sender: sender,
        receiver: receiver,
        content: "a" * 500
      )
      expect(message).to be_valid
    end
  end

  describe 'factory' do
    it 'creates a valid message' do
      message = Message.create!(
        request: request,
        sender: sender,
        receiver: receiver,
        content: "Test message"
      )
      expect(message).to be_persisted
      expect(message.content).to eq("Test message")
    end
  end
end
