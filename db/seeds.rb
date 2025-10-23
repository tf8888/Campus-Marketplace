# db/seeds.rb

# --- 1. Setup Prerequisites (Users and Categories) ---
# We need users and categories to exist before we can create items
# that belong to them.

puts "Finding or creating users..."
user1 = User.find_or_create_by!(email: "alice@example.com") do |user|
  user.name = "Alice Smith"
  user.role = "member"
  # Note: The CreateUsers migration provided doesn't include a password
  # column (e.g., 'password_digest'). If your User model uses
  # 'has_secure_password', you'll need to add that column
  # and set 'user.password' and 'user.password_confirmation' here.
end

user2 = User.find_or_create_by!(email: "bob@example.com") do |user|
  user.name = "Bob Johnson"
  user.role = "admin"
end

puts "Finding or creating categories..."
electronics = Category.find_or_create_by!(name: "Electronics")
books = Category.find_or_create_by!(name: "Books")
furniture = Category.find_or_create_by!(name: "Furniture")

# --- 2. Create Items ---
# Now we create the items, ensuring they follow the validations:
# - Must have a title
# - Must have a user and category
# - Must be EITHER for_sale OR for_lend (XOR validation)

puts "Creating items..."

Item.create!([
  {
    title: "Used Laptop - 15 inch",
    description: "Good working condition. 16GB RAM, 512GB SSD. Great for a student.",
    condition: "Used - Good",
    available: true,
    for_lend: false,  # <-- Must be false if for_sale is true
    for_sale: true,   # <--
    location: "Downtown Library",
    image_url: "https://example.com/images/laptop.png",
    user: user1,      # Assign to user1
    category: electronics
  },
  {
    title: "Intro to Algorithms Textbook",
    description: "Slightly used textbook for CS 301. No markings inside.",
    condition: "Used - Like New",
    available: true,
    for_lend: true,   # <-- Must be true if for_sale is false
    for_sale: false,  # <--
    location: "Campus Bookstore",
    image_url: "https://example.com/images/book.png",
    user: user2,      # Assign to user2
    category: books
  },
  {
    title: "Wooden Desk Chair",
    description: "Simple wooden chair, perfect for a desk. Has some minor scuffs.",
    condition: "Used - Fair",
    available: true,
    for_lend: false,  # <--
    for_sale: true,   # <--
    location: "123 Main St",
    image_url: "https://example.com/images/chair.png",
    user: user2,      # Assign to user2
    category: furniture
  },
  {
    title: "High-Quality USB-C Monitor",
    description: "27-inch 4K monitor. Great colors. Only available to lend, not for sale.",
    condition: "New",
    available: true,
    for_lend: true,   # <--
    for_sale: false,  # <--
    location: "Co-working Space",
    image_url: "https://example.com/images/monitor.png",
    user: user1,      # Assign to user1
    category: electronics
  }
])

puts "Seed finished."
puts "Created #{User.count} users."
puts "Created #{Category.count} categories."
puts "Created #{Item.count} items."
