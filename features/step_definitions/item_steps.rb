# features/step_definitions/item_steps.rb

Given('the following users exist:') do |table|
  table.hashes.each do |user|
    User.create!(
      name: user['name'],
      email: user['email'],
      role: user['role']
    )
  end
end

Given('the following categories exist:') do |table|
  table.hashes.each do |category|
    Category.create!(
      name: category['name'],
      description: category['description']
    )
  end
end

Given('the following items exist:') do |table|
  table.hashes.each do |item|
    user = User.find_by(email: item['user'])
    category = Category.find_by(name: item['category'])
    
    Item.create!(
      title: item['title'],
      description: item['description'],
      available: item['available'] == 'true',
      user: user,
      category: category,
      for_sale: item['for_sale'] == 'true',
      for_lend: item['for_lend'] == 'true',
      condition: item['condition'] || 'Good',
      location: item['location'] || 'College Station, TX'
    )
  end
end

Given('I am logged in as {string}') do |email|
  @current_user = User.find_by(email: email)
  # Simulate login - adjust based on your authentication system
  # For Devise: login_as(@current_user, scope: :user)
  # For custom auth: session[:user_id] = @current_user.id
  visit root_path
  # Add your login steps here based on your auth system
end

When('I visit the new item page') do
  visit new_item_path
end

When('I visit the items page') do
  visit items_path
end

When('I visit my listings page') do
  visit my_listings_items_path
end

When('I visit the item page for {string}') do |title|
  item = Item.find_by(title: title)
  visit item_path(item)
end

When('I visit the edit page for {string}') do |title|
  item = Item.find_by(title: title)
  visit edit_item_path(item)
end

When('I try to visit the edit page for {string}') do |title|
  item = Item.find_by(title: title)
  visit edit_item_path(item)
end

When('I try to visit the item page for {string}') do |title|
  item = Item.find_by(title: title)
  visit item_path(item)
end

When('I fill in the item form with:') do |table|
  table.hashes.each do |row|
    field = row['field']
    value = row['value']
    
    case field
    when 'Category'
      select value, from: 'item_category_id'
    when 'Condition'
      # Check if it's a select field or text field
      begin
        select value, from: 'item_condition'
      rescue Capybara::ElementNotFound
        fill_in 'item_condition', with: value
      end
    else
      fill_in "item_#{field.downcase.gsub(' ', '_')}", with: value
    end
  end
end

When('I fill in {string} with {string}') do |field, value|
  field_name = "item_#{field.downcase.gsub(' ', '_')}"
  
  # Special handling for Category field (it's a select dropdown)
  if field == 'Category'
    select value, from: 'item_category_id'
  elsif page.has_select?(field_name)
    select value, from: field_name
  else
    fill_in field_name, with: value
  end
end

When('I fill in {string} with a string of {int} characters') do |field, length|
  long_string = 'a' * length
  fill_in "item_#{field.downcase}", with: long_string
end

When('I select {string} from {string}') do |value, field|
  if field == 'Category'
    select value, from: 'item_category_id'
  else
    select value, from: "item_#{field.downcase.gsub(' ', '_')}"
  end
end

When('I check {string}') do |checkbox|
  case checkbox
  when 'For Sale'
    check 'item_for_sale'
  when 'For Lend'
    check 'item_for_lend'
  end
end

When('I submit the item form') do
  if page.has_button?('Create Item')
    click_button 'Create Item'
  elsif page.has_button?('Update Item')
    click_button 'Update Item'
  elsif page.has_button?('Submit')
    click_button 'Submit'
  else
    # Try to find any submit button
    find('input[type="submit"]').click
  end
end

When('I search for {string}') do |query|
  fill_in 'query', with: query
  click_button 'Search'
end

When('I click {string}') do |button|
  click_link_or_button button
end

When('I try to delete the item {string}') do |title|
  item = Item.find_by(title: title)
  # Attempt to send DELETE request directly
  page.driver.submit :delete, item_path(item), {}
end

Then('I should see this {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should not see this {string}') do |text|
  expect(page).not_to have_content(text)
end

Then('I should be on the items page') do
  expect(current_path).to eq(items_path)
end

Then('the item should belong to {string}') do |email|
  user = User.find_by(email: email)
  item = Item.order(created_at: :desc).first
  expect(item.user).to eq(user)
end

Then('the item {string} should not exist') do |title|
  expect(Item.find_by(title: title)).to be_nil
end

Then('the item {string} should still exist') do |title|
  expect(Item.find_by(title: title)).not_to be_nil
end

Then('the item {string} should be unavailable') do |title|
  item = Item.find_by(title: title)
  expect(item.available).to be false
end

Then('I should see an error message about title') do
  expect(page).to have_content("Title can't be blank")
end

Then('I should see an error message about title length') do
  expect(page).to have_content("Title is too long")
end

Then('I should see an error message about description length') do
  expect(page).to have_content("Description is too long")
end