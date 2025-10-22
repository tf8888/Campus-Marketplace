Given('the app is in test mode') do
  expect(OmniAuth.config.test_mode).to be true
end

When('I visit the home page') do
  visit '/'
end

Then('I should be on the login page') do
  expect(page).to have_current_path('/login', ignore_query: true)
end

When('I sign in with Google') do
  visit '/auth/google_oauth2/callback'
end

Then('I should be on the home page') do
  expect(page).to have_current_path('/', ignore_query: true)
end

When('I visit the OAuth failure callback') do
  visit '/auth/failure'
end
