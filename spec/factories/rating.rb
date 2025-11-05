FactoryBot.define do
  factory :rating do
    score { 5 } # default score
    association :rater, factory: :user
    association :ratee, factory: :user
    association :request
  end
end
