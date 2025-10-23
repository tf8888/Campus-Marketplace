# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    # Use sequence to make sure email is always unique
    sequence(:email) { |n| "testuser#{n}@example.com" }

    # Use sequence for name too, since it's indexed
    sequence(:name)  { |n| "Test User #{n}" }

    # Set a default value for the role
    role { "user" }
  end
end
