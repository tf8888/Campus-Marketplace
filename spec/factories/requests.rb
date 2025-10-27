FactoryBot.define do
  factory :request do
    association :item
    association :user
    status { "pending" }
    message { "This is a sample request message." }
  end
end
