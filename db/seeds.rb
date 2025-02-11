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
# Delete existing records to avoid duplicates
Item.delete_all
Bin.delete_all
User.delete_all

# Helper method to create users with unique bins and items
def create_user_with_bins_and_items(name, email, bins_and_items)
  user = User.find_or_create_by!(email: email) do |u|
    u.name = name
    u.password = "Abc1234!"
  end

  # Create unique bins and items for this user
  bins_and_items.each do |bin_info|
    bin = user.bins.create!(name: bin_info[:name], location: bin_info[:location], category_name: bin_info[:category])

    bin_info[:items].each do |item|
      bin.items.create!(name: item[:name], description: item[:description], created_date: Time.now, value: item[:value])
    end
  end

  puts "✅ Created user: #{user.name} (#{user.email}) with #{bins_and_items.size} bins and #{bins_and_items.sum { |b| b[:items].size }} items"
end

# Define unique bins and items for each user
admin_bins = [
  { name: "Server Room Equipment", location: "Server Room", category: "IT",
    items: [
      { name: "Rack Server", description: "Dell PowerEdge Server", value: 2500.0 },
      { name: "UPS Battery", description: "Uninterruptible Power Supply", value: 400.0 }
    ]
  },
  { name: "Networking", location: "Tech Lab", category: "IT",
    items: [
      { name: "Cisco Router", description: "Cisco ISR 4000 Series", value: 1500.0 },
      { name: "Ethernet Switch", description: "Netgear 24-Port Switch", value: 200.0 }
    ]
  }
]

rafael_bins = [
  { name: "Home Electronics", location: "Living Room", category: "Gadgets",
    items: [
      { name: "Smart TV", description: "Samsung 55-inch 4K TV", value: 700.0 },
      { name: "Soundbar", description: "Bose Soundbar 700", value: 500.0 }
    ]
  },
  { name: "Office Essentials", location: "Office Desk", category: "Work",
    items: [
      { name: "Laptop", description: "MacBook Pro 16-inch", value: 2400.0 },
      { name: "Monitor", description: "Dell 27-inch Monitor", value: 300.0 }
    ]
  }
]

# Create users with their specific bins and items
create_user_with_bins_and_items("Admin", "admin@example.com", admin_bins)
create_user_with_bins_and_items("Rafael", "rafaeldms27@icloud.com", rafael_bins)
