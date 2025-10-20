class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.last_login_at = Time.current
      user.save!
    end
  end

  def name
    [first_name, last_name].compact.join(" ")
  end
end
