class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :requests, dependent: :destroy
  has_many :requesting_users, through: :requests, source: :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validate :for_sale_xor_for_lend
  validate :price_required_for_sale

  private

  def for_sale_xor_for_lend
    unless for_sale ^ for_lend
      errors.add(:base, "Item must be either for sale or for lend, not both or neither.")
    end
  end

  def price_required_for_sale
    if for_sale && price.blank?
      errors.add(:price, "is required for items that are for sale")
    end
  end
end
