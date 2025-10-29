class User < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :requested_items, through: :requests, source: :item
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: :receiver_id, dependent: :destroy
  has_many :ratings_given, class_name: 'Rating', foreign_key: 'rater_id', dependent: :destroy
  has_many :ratings_received, class_name: 'Rating', foreign_key: 'ratee_id', dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  def average_rating
    return nil if ratings_received.empty?
    
    (ratings_received.sum(:score).to_f / ratings_received.count).round(1)
  end
  
   def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.save!
    end
  end
end
