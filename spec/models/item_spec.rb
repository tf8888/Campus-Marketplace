require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user) { User.create!(name: "Test User", email: "test@example.com", role: "member", verified: true) }
  let(:category) { Category.create!(name: "Electronics") }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:requests).dependent(:destroy) }
    it { should have_many(:requesting_users).through(:requests) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_length_of(:description).is_at_most(1000) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'database columns' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:price).of_type(:decimal) }
    it { should have_db_column(:condition).of_type(:string) }
    it { should have_db_column(:available).of_type(:boolean) }
    it { should have_db_column(:for_sale).of_type(:boolean) }
    it { should have_db_column(:for_lend).of_type(:boolean) }
    it { should have_db_column(:location).of_type(:string) }
    it { should have_db_column(:image_url).of_type(:string) }
  end

  describe 'for_sale_xor_for_lend validation' do
    it 'is valid when for_sale is true and for_lend is false' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        for_lend: false,
        price: 100,
        available: true,
        condition: "New"
      )
      expect(item).to be_valid
    end

    it 'is valid when for_lend is true and for_sale is false' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: false,
        for_lend: true,
        available: true,
        condition: "New"
      )
      expect(item).to be_valid
    end

    it 'is invalid when both for_sale and for_lend are true' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        for_lend: true,
        price: 100,
        available: true,
        condition: "New"
      )
      expect(item).not_to be_valid
      expect(item.errors[:base]).to include("Item must be either for sale or for lend, not both or neither.")
    end

    it 'is invalid when both for_sale and for_lend are false' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: false,
        for_lend: false,
        available: true,
        condition: "New"
      )
      expect(item).not_to be_valid
      expect(item.errors[:base]).to include("Item must be either for sale or for lend, not both or neither.")
    end
  end

  describe 'price_required_for_sale validation' do
    it 'requires price when for_sale is true' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        for_lend: false,
        available: true,
        condition: "New"
      )
      expect(item).not_to be_valid
      expect(item.errors[:price]).to include("is required for items that are for sale")
    end

    it 'does not require price when for_lend is true' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: false,
        for_lend: true,
        available: true,
        condition: "New"
      )
      expect(item).to be_valid
    end

    it 'allows valid price for sale items' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        for_lend: false,
        price: 50.00,
        available: true,
        condition: "New"
      )
      expect(item).to be_valid
    end
  end

  describe 'price numericality' do
    it 'does not allow negative prices' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        for_lend: false,
        price: -10,
        available: true,
        condition: "New"
      )
      expect(item).not_to be_valid
      expect(item.errors[:price]).to include("must be greater than or equal to 0")
    end

    it 'allows zero price' do
      item = Item.new(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        for_lend: false,
        price: 0,
        available: true,
        condition: "New"
      )
      expect(item).to be_valid
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated requests when item is destroyed' do
      item = Item.create!(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        price: 100,
        available: true,
        condition: "New"
      )
      requester = User.create!(name: "Requester", email: "requester@example.com", role: "member", verified: true)
      Request.create!(item: item, user: requester, status: "pending", message: "I want this")
      
      expect { item.destroy }.to change { Request.count }.by(-1)
    end
  end
end
