Given('there are no users') do
  User.delete_all
end

Given('a user exists with:') do |table|
  attrs = table.rows_hash.symbolize_keys
  User.create!(attrs)
end

When('I validate a new user with:') do |table|
  attrs = table.rows_hash.symbolize_keys
  @user = User.new(attrs)
  @user.valid?
end

Then('the user should be invalid') do
  expect(@user).to be_invalid
end

Then('the error on {string} should include {string}') do |field, message|
  expect(@user.errors[field.to_sym]).to include(message)
end
