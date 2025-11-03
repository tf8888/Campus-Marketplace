class Request < ApplicationRecord
  belongs_to :item
  belongs_to :user

  has_many :messages, dependent: :destroy
  has_one :rating, dependent: :destroy

  validates :item_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected] }
  validates :message, length: { maximum: 1000 }
  validate :user_cannot_request_own_item

  private

  def user_cannot_request_own_item
    return unless item_id.present? && user_id.present?
    item = Item.find_by(id: item_id)
    return unless item
    errors.add(:user_id, "cannot request their own item") if item.user_id == user_id
  end
end
