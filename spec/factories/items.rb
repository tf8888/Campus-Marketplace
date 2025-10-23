FactoryBot.define do
  factory :item do
    association :user 
    association :category # <-- The line you added before, which is correct

    title { "Sample Item" }
    description { "A great description." }
    condition { "Good" }
    location { "Closet" }
    available { true }

    # To satisfy the for_sale_xor_for_lend validation
    for_sale { true }
    for_lend { false }
  end
end