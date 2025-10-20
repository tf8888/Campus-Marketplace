class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :requests, dependent: :destroy
  has_many :requesting_users, through: :requests, source: :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validate :for_sale_xor_for_lend

  private

  def for_sale_xor_for_lend
    unless for_sale ^ for_lend
      errors.add(:base, "Item must be either for sale or for lend, not both or neither.")
    end
  end
end
