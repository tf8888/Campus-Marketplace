FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { "A test category description." }
  end
end
