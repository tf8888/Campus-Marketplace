class Message < ApplicationRecord
  belongs_to :request
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :content, presence: true, length: { maximum: 500 }
  validate :sender_and_receiver_cannot_be_the_same

  private

  def sender_and_receiver_cannot_be_the_same
    errors.add(:receiver, "can't be the same as sender") if sender_id == receiver_id
  end
end
