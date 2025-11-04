require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should have_many(:items).dependent(:destroy) }
  end

  describe 'validations' do
    subject { Category.new(name: "Electronics") }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:description).is_at_most(500) }
  end

  describe 'database columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      category = Category.create!(name: "Test Category", description: "Test description")
      expect(category).to be_valid
    end
  end

  describe 'name uniqueness' do
    it 'does not allow duplicate names (case insensitive)' do
      Category.create!(name: "Electronics")
      duplicate = Category.new(name: "electronics")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated items when category is destroyed' do
      user = User.create!(name: "Test User", email: "test@example.com", role: "member", verified: true)
      category = Category.create!(name: "Electronics")
      item = Item.create!(
        title: "Test Item",
        user: user,
        category: category,
        for_sale: true,
        price: 100,
        available: true,
        condition: "New"
      )

      expect { category.destroy }.to change { Item.count }.by(-1)
    end
  end
end
