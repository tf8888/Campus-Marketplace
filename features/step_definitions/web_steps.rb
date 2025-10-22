Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

When('I click {string}') do |link_text|
  click_link link_text
end

Then('I should not see {string}') do |text|
  expect(page).not_to have_content(text)
end

Then('I should see the alert {string}') do |message|
  expect(page).to have_content(message)
end
