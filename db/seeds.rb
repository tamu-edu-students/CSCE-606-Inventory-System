# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing records (optional, only if you want to delete everything before seeding)

# Find or create the user
# Clear existing records in the correct order
puts "Destroying existing records..."
#ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF")
Item.destroy_all
Bin.destroy_all
Location.destroy_all
User.destroy_all
#ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")

puts "Running seed..."
# Helper method to create users with unique bins and items
def create_user_with_bins_and_items(name, email, bins_and_items)
  puts "Creating user #{name} with email #{email}..."
  user = User.find_or_create_by!(email: email) do |u|
    u.name = name
    u.password = "Abc1234!"
    u.password_confirmation = "Abc1234!"  # Ensure Devise processes it
  end

  puts "✅ Created User: #{user.name} (#{user.email}) with ID: #{user.id}"

  # Create locations for this user
  locations = [
    Location.create!(name: "Warehouse A", user: user),
    Location.create!(name: "Tech Lab", user: user),
    Location.create!(name: "Living Room", user: user),
    Location.create!(name: "Office Desk", user: user)
  ]

  puts "✅ Created Locations for User: #{user.name} (#{user.email})"

  # Create bins with assigned locations
  bins_and_items.each_with_index do |bin_info, index|
    location = locations[index % locations.size] # Assign a location in a round-robin fashion
    puts "Creating bin #{bin_info[:name]} at location #{location.name}..."
    bin = user.bins.create!(name: bin_info[:name], location: location, category_name: bin_info[:category])
    puts "✅ Created Bin: #{bin.name} (#{bin.location.name}) for User: #{user.name} (#{user.email})"

    # Generate and save QR Code
    bin.send(:update_qr_code)
    puts "✅ Generated QR Code for Bin: #{bin.name}"

    bin_info[:items].each do |item|
      puts "Creating item #{item[:name]} in bin #{bin.name}..."
      bin.items.create!(name: item[:name], description: item[:description], created_date: Time.now, value: item[:value], location: bin.location, user: user)  # Ensure user: user is set correctly
      puts "✅ Created Item: #{item[:name]} in Bin: #{bin.name} for User: #{user.name} (#{user.email})"
    end
  end

  puts "✅ Created user: #{user.name} (#{user.email}) with #{bins_and_items.size} bins, #{locations.size} locations, and #{bins_and_items.sum { |b| b[:items].size }} items"
end

# Define unique bins and items for each user
admin_bins = [
  { name: "Server Room Equipment", category: "IT",
    items: [
      { name: "Rack Server", description: "Dell PowerEdge Server", value: 2500.0 },
      { name: "UPS Battery", description: "Uninterruptible Power Supply", value: 400.0 }
    ]
  },
  { name: "Networking", category: "IT",
    items: [
      { name: "Cisco Router", description: "Cisco ISR 4000 Series", value: 1500.0 },
      { name: "Ethernet Switch", description: "Netgear 24-Port Switch", value: 200.0 }
    ]
  }
]

rafael_bins = [
  { name: "Home Electronics", category: "Gadgets",
    items: [
      { name: "Smart TV", description: "Samsung 55-inch 4K TV", value: 700.0 },
      { name: "Soundbar", description: "Bose Soundbar 700", value: 500.0 }
    ]
  },
  { name: "Office Essentials", category: "Work",
    items: [
      { name: "Laptop", description: "MacBook Pro 16-inch", value: 2400.0 },
      { name: "Monitor", description: "Dell 27-inch Monitor", value: 300.0 }
    ]
  }
]

# Create users with their specific bins and items
create_user_with_bins_and_items("Admin", "admin@example.com", admin_bins)
create_user_with_bins_and_items("Rafael", "rafaeldms27@icloud.com", rafael_bins)
