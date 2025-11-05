class Rating < ApplicationRecord
  belongs_to :rater, class_name: "User"
  belongs_to :ratee, class_name: "User"
  belongs_to :request

  validates :score, presence: true, inclusion: { in: 1..10, message: "must be between 1 and 10" }

  validate :rater_must_be_request_user
  validate :rater_cannot_be_ratee
  validate :request_must_be_approved
  validates :request_id, uniqueness: { scope: :rater_id, message: "has already been rated" }

  private

  def rater_must_be_request_user
    errors.add(:rater, "must be the user who made the request") if rater_id != request.user_id
  end

  def rater_cannot_be_ratee
    errors.add(:rater, "cannot rate themselves") if rater_id == ratee_id
  end

  def request_must_be_approved
    errors.add(:request, "must be approved before rating") unless request.status == "approved"
  end
end
