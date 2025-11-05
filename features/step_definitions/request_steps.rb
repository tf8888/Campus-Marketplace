# features/step_definitions/request_steps.rb

Given('the following requests exist:') do |table|
  table.hashes.each do |row|
    item = Item.find_by(title: row['item_title'])
    requester = User.find_by(email: row['requester_email'])
    raise "Item not found: #{row['item_title']}" unless item
    raise "User not found: #{row['requester_email']}" unless requester

    Request.create!(
      item: item,
      user: requester,
      status: row['status'] || 'pending',
      message: row['message'] || 'Test request'
    )
  end
end

When('I visit the incoming requests page for {string}') do |email|
  user = User.find_by(email: email)
  visit incoming_requests_user_path(user)
end

When('I click the first {string} button') do |button_text|
  # button_to creates a form with a submit button; find and click it
  page.save_screenshot('debug.png') if ENV['DEBUG']
  first(:button, button_text, minimum: 1).click
end
