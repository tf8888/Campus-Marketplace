# Message step definitions

When('I try to create a message with sender and receiver {string} for request {string}') do |email, item_title|
  item = Item.find_by(title: item_title)
  request = Request.find_by(item: item)
  user = User.find_by(email: email)

  @test_message = Message.new(
    request: request,
    sender: user,
    receiver: user,
    content: "Test message"
  )
  @test_message.valid?
end

When('I try to create a message without content for request {string}') do |item_title|
  item = Item.find_by(title: item_title)
  request = Request.find_by(item: item)
  buyer = User.find_by(email: "buyer@example.com")
  owner = User.find_by(email: "owner@example.com")

  @test_message = Message.new(
    request: request,
    sender: buyer,
    receiver: owner,
    content: nil
  )
  @test_message.valid?
end

When('I try to create a message with {int} characters for request {string}') do |char_count, item_title|
  item = Item.find_by(title: item_title)
  request = Request.find_by(item: item)
  buyer = User.find_by(email: "buyer@example.com")
  owner = User.find_by(email: "owner@example.com")

  @test_message = Message.new(
    request: request,
    sender: buyer,
    receiver: owner,
    content: "a" * char_count
  )
  @test_message.valid?
end

Then('the message should be invalid with error {string}') do |error_text|
  expect(@test_message).not_to be_valid
  expect(@test_message.errors.full_messages.join(" ")).to include(error_text)
end
