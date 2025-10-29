# --- 1. Setup Prerequisites (Users and Categories) ---
puts "Finding or creating users..."
user1 = User.find_or_create_by!(email: "alice@example.com") do |user|
  user.name = "Alice Smith"
  user.role = "member"
  user.address = "123 Main St, College Station, TX"
  user.contact_number = "(979) 123-4567"
  user.verified = true
end

user2 = User.find_or_create_by!(email: "bob@example.com") do |user|
  user.name = "Bob Johnson"
  user.role = "admin"
  user.address = "456 University Dr, College Station, TX"
  user.contact_number = "(979) 987-6543"
  user.verified = true
end

puts "Finding or creating categories..."
electronics = Category.find_or_create_by!(name: "Electronics")
books = Category.find_or_create_by!(name: "Books")
furniture = Category.find_or_create_by!(name: "Furniture")

# --- 2. Create Items ---
puts "Creating items..."
item1 = Item.create!(
  title: "Used Laptop - 15 inch",
  description: "Good working condition. 16GB RAM, 512GB SSD. Great for a student.",
  condition: "Used - Good",
  available: true,
  for_lend: false,
  for_sale: true,
  location: "Downtown Library",
  image_url: "https://example.com/images/laptop.png",
  user: user1,      # Alice's Item
  category: electronics
)

item2 = Item.create!(
  title: "Intro to Algorithms Textbook",
  description: "Slightly used textbook for CS 301. No markings inside.",
  condition: "Used - Like New",
  available: true,
  for_lend: true,
  for_sale: false,
  location: "Campus Bookstore",
  image_url: "https://example.com/images/book.png",
  user: user2,      # Bob's Item
  category: books
)

item3 = Item.create!(
  title: "Wooden Desk Chair",
  description: "Simple wooden chair, perfect for a desk. Has some minor scuffs.",
  condition: "Used - Fair",
  available: true,
  for_lend: false,
  for_sale: true,
  location: "123 Main St",
  image_url: "https://example.com/images/chair.png",
  user: user2,      # Bob's Item
  category: furniture
)

item4 = Item.create!(
  title: "High-Quality USB-C Monitor",
  description: "27-inch 4K monitor. Great colors. Only available to lend, not for sale.",
  condition: "New",
  available: true,
  for_lend: true,
  for_sale: false,
  location: "Co-working Space",
  image_url: "https://example.com/images/monitor.png",
  user: user1,      # Alice's Item
  category: electronics
)

# --- 3. (New Section) Create Approved Requests and Ratings ---
puts "Creating completed requests and ratings..."

# Scenario 1: Bob (user2) rates Alice (user1)
# Bob requests Alice's Laptop
req1 = Request.create!(
  item: item1,      # Alice's Laptop
  user: user2,      # Requester is Bob
  status: 'approved', # Must be 'approved'
  message: 'This is a test request for rating.'
)
# Bob gives Alice a 9
Rating.create!(
  score: 9,
  rater: user2,     # Rater is Bob
  ratee: user1,     # Ratee is Alice
  request: req1
)

# Scenario 2: Bob (user2) rates Alice (user1) again
# Bob requests Alice's Monitor
req2 = Request.create!(
  item: item4,      # Alice's Monitor
  user: user2,      # Requester is Bob
  status: 'approved', # Must be 'approved'
  message: 'This is another test request.'
)
# Bob gives Alice a 7
Rating.create!(
  score: 7,
  rater: user2,     # Rater is Bob
  ratee: user1,     # Ratee is Alice
  request: req2
)
# (Alice's average score should now be (9+7)/2 = 8.0)

# Scenario 3: Alice (user1) rates Bob (user2)
# Alice requests Bob's Textbook
req3 = Request.create!(
  item: item2,      # Bob's Textbook
  user: user1,      # Requester is Alice
  status: 'approved', # Must be 'approved'
  message: 'Test request for Bob.'
)
# Alice gives Bob a 10
Rating.create!(
  score: 10,
  rater: user1,     # Rater is Alice
  ratee: user2,     # Ratee is Bob
  request: req3
)
# (Bob's average score should now be 10.0)


puts "Seed finished."
puts "Created #{User.count} users."
puts "Created #{Category.count} categories."
puts "Created #{Item.count} items."
puts "Created #{Request.count} requests."
puts "Created #{Rating.count} ratings."