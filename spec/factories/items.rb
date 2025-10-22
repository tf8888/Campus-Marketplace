FactoryBot.define do
  factory :item do
    sequence(:title) { |n| "Sample Item #{n}" }
    sequence(:description) { |n| "This is a sample item description for item #{n}." }
    condition { "New" }
    available { true }
    for_lend { false }
    for_sale { true }
    location { "Sample Location" }
    image_url { "http://example.com/sample_image.jpg" }
    association :user
    association :category
  end
end
