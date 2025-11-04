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

# Helper method to copy seed images to public/uploads/items/
def seed_image_path(filename)
  # Try multiple extensions
  base_name = File.basename(filename, File.extname(filename))
  extensions = [ '.jpg', '.jpeg', '.png', '.gif', '.webp' ]

  source = nil
  extensions.each do |ext|
    potential_path = Rails.root.join('db', 'seed_images', "#{base_name}#{ext}")
    if File.exist?(potential_path)
      source = potential_path
      break
    end
  end

  return nil unless source

  # Create uploads directory if it doesn't exist
  dest_dir = Rails.root.join('public', 'uploads', 'items')
  FileUtils.mkdir_p(dest_dir)

  # Generate a unique filename to avoid conflicts
  ext = File.extname(source)
  dest_filename = "seed_#{base_name}_#{SecureRandom.hex(8)}#{ext}"
  dest_path = dest_dir.join(dest_filename)

  # Copy the file
  FileUtils.cp(source, dest_path)

  # Return the URL path
  "/uploads/items/#{dest_filename}"
end

item1 = Item.find_or_create_by!(title: "Used Laptop - 15 inch", user: user1) do |item|
  item.description = "Good working condition. 16GB RAM, 512GB SSD. Great for a student."
  item.condition = "Used - Good"
  item.available = true
  item.for_lend = false
  item.for_sale = true
  item.price = 450.00
  item.location = "Downtown Library"
  item.category = electronics
end
# Update price if item already exists
item1.update!(price: 450.00) if item1.for_sale && item1.price.nil?
item1.update!(image_url: seed_image_path("laptop.jpg") || item1.image_url || "https://example.com/images/laptop.png")

item2 = Item.find_or_create_by!(title: "Intro to Algorithms Textbook", user: user2) do |item|
  item.description = "Slightly used textbook for CS 301. No markings inside."
  item.condition = "Used - Like New"
  item.available = true
  item.for_lend = true
  item.for_sale = false
  item.price = nil
  item.location = "Campus Bookstore"
  item.category = books
end
item2.update!(price: 30.00) if item2.price.nil?
item2.update!(image_url: seed_image_path("book.jpg") || item2.image_url || "https://example.com/images/book.png")

item3 = Item.find_or_create_by!(title: "Wooden Desk Chair", user: user2) do |item|
  item.description = "Simple wooden chair, perfect for a desk. Has some minor scuffs."
  item.condition = "Used - Fair"
  item.available = true
  item.for_lend = false
  item.for_sale = true
  item.price = 35.50
  item.location = "123 Main St"
  item.category = furniture
end
# Update price if item already exists
item3.update!(price: 35.50) if item3.for_sale && item3.price.nil?
item3.update!(image_url: seed_image_path("chair.jpg") || item3.image_url || "https://example.com/images/chair.png")

item4 = Item.find_or_create_by!(title: "High-Quality USB-C Monitor", user: user1) do |item|
  item.description = "27-inch 4K monitor. Great colors. Only available to lend, not for sale."
  item.condition = "New"
  item.available = true
  item.for_lend = true
  item.for_sale = false
  item.price = nil
  item.location = "Co-working Space"
  item.category = electronics
end
item4.update!(price: 100.00) if item4.price.nil?
item4.update!(image_url: seed_image_path("monitor.jpg") || item4.image_url || "https://example.com/images/monitor.png")

# --- 3. (New Section) Create Approved Requests and Ratings ---
puts "Creating completed requests and ratings..."

# Scenario 1: Bob (user2) rates Alice (user1)
# Bob requests Alice's Laptop
req1 = Request.find_or_create_by!(item: item1, user: user2) do |request|
  request.status = 'approved' # Must be 'approved'
  request.message = 'This is a test request for rating.'
end

# Bob gives Alice a 9
Rating.find_or_create_by!(rater: user2, ratee: user1, request: req1) do |rating|
  rating.score = 9
end

# Scenario 2: Bob (user2) rates Alice (user1) again
# Bob requests Alice's Monitor
req2 = Request.find_or_create_by!(item: item4, user: user2) do |request|
  request.status = 'approved' # Must be 'approved'
  request.message = 'This is another test request.'
end

# Bob gives Alice a 7
Rating.find_or_create_by!(rater: user2, ratee: user1, request: req2) do |rating|
  rating.score = 7
end
# (Alice's average score should now be (9+7)/2 = 8.0)

# Scenario 3: Alice (user1) rates Bob (user2)
# Alice requests Bob's Textbook
req3 = Request.find_or_create_by!(item: item2, user: user1) do |request|
  request.status = 'approved' # Must be 'approved'
  request.message = 'Test request for Bob.'
end

# Alice gives Bob a 10
Rating.find_or_create_by!(rater: user1, ratee: user2, request: req3) do |rating|
  rating.score = 10
end
# (Bob's average score should now be 10.0)


puts "Seed finished."
puts "Created #{User.count} users."
puts "Created #{Category.count} categories."
puts "Created #{Item.count} items."
puts "Created #{Request.count} requests."
puts "Created #{Rating.count} ratings."
