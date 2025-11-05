# Category step definitions

Then('I should see {string} in the category options') do |category_name|
  expect(page).to have_select('item[category_id]', with_options: [ category_name ])
end

When('I try to create a duplicate category {string}') do |category_name|
  # This is a model-level test, not a UI action
  @duplicate_category = Category.new(name: category_name, description: "Duplicate")
end

Then('the category should not be created') do
  expect(@duplicate_category.save).to be false
  expect(@duplicate_category.errors[:name]).to include("has already been taken")
end

When('the category {string} is destroyed') do |category_name|
  category = Category.find_by(name: category_name)
  category.destroy
end
