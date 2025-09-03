# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing inventory and menu data for fresh start
InventoryItem.destroy_all
MenuItem.destroy_all

# Create sample suppliers
suppliers = [
  { supplier_code: 'SUP001', name: 'ABC Suppliers', phone_number: '123-456-7890', address: '123 Main St', email: 'contact@abc.com' },
  { supplier_code: 'SUP002', name: 'XYZ Distributors', phone_number: '987-654-3210', address: '456 Oak Ave', email: 'info@xyz.com' },
  { supplier_code: 'VEG001', name: 'Fresh Vegetables Ltd', phone_number: '+94112345678', address: '123 Market Street, Colombo', email: 'orders@freshveg.lk' },
  { supplier_code: 'DAIRY001', name: 'Lanka Dairy Products', phone_number: '+94112345679', address: '456 Dairy Road, Kandy', email: 'sales@lankadairy.lk' },
  { supplier_code: 'MEAT001', name: 'Quality Meat Suppliers', phone_number: '+94112345680', address: '789 Butcher Lane, Galle', email: 'orders@qualitymeat.lk' }
]

suppliers.each do |supplier_data|
  Supplier.find_or_create_by!(supplier_code: supplier_data[:supplier_code]) do |supplier|
    supplier.name = supplier_data[:name]
    supplier.phone_number = supplier_data[:phone_number]
    supplier.address = supplier_data[:address]
    supplier.email = supplier_data[:email]
  end
end

# Get suppliers for inventory items
veg_supplier = Supplier.find_by(supplier_code: 'VEG001')
dairy_supplier = Supplier.find_by(supplier_code: 'DAIRY001')
meat_supplier = Supplier.find_by(supplier_code: 'MEAT001')

# Create sample inventory items with varying expiry dates
InventoryItem.create!([
  {
    name: 'Eggs',
    quantity: 50,
    unit: 'pieces',
    expiry_date: Date.current + 2.days, # Expiring soon
    supplier: dairy_supplier,
    created_by: 'storekeeper'
  },
  {
    name: 'Chicken',
    quantity: 10,
    unit: 'kg',
    expiry_date: Date.current + 1.day, # Expiring tomorrow
    supplier: meat_supplier,
    created_by: 'storekeeper'
  },
  {
    name: 'Milk',
    quantity: 2, # Low stock
    unit: 'liters',
    expiry_date: Date.current - 1.day, # Expired
    supplier: dairy_supplier,
    created_by: 'storekeeper'
  },
  {
    name: 'Tomatoes',
    quantity: 15,
    unit: 'kg',
    expiry_date: Date.current + 5.days,
    supplier: veg_supplier,
    created_by: 'storekeeper'
  },
  {
    name: 'Onions',
    quantity: 20,
    unit: 'kg',
    expiry_date: Date.current + 10.days,
    supplier: veg_supplier,
    created_by: 'storekeeper'
  },
  {
    name: 'Rice',
    quantity: 50,
    unit: 'kg',
    expiry_date: Date.current + 30.days,
    supplier: veg_supplier,
    created_by: 'storekeeper'
  },
  {
    name: 'Bread',
    quantity: 3, # Low stock
    unit: 'loaves',
    expiry_date: Date.current + 2.days,
    supplier: dairy_supplier,
    created_by: 'storekeeper'
  },
  {
    name: 'Cheese',
    quantity: 5,
    unit: 'kg',
    expiry_date: Date.current + 7.days,
    supplier: dairy_supplier,
    created_by: 'storekeeper'
  }
])

# Create sample menu items
MenuItem.create!([
  {
    name: 'Chicken Fried Rice',
    description: 'Delicious fried rice with chicken and vegetables',
    price: 850.00,
    ingredients: 'Rice, Chicken, Onions, Eggs',
    menu_date: Date.current,
    status: 'active',
    created_by: 'manager'
  },
  {
    name: 'Vegetable Curry',
    description: 'Mixed vegetable curry with coconut milk',
    price: 650.00,
    ingredients: 'Tomatoes, Onions, Mixed Vegetables',
    menu_date: Date.current,
    status: 'active',
    created_by: 'manager'
  },
  {
    name: 'Cheese Omelet',
    description: 'Fluffy omelet with fresh cheese',
    price: 450.00,
    ingredients: 'Eggs, Cheese, Onions',
    menu_date: Date.current + 1.day,
    status: 'draft',
    created_by: 'manager'
  }
])

# Create sample transactions if none exist
if StorekeeperTransaction.count == 0
  5.times do |i|
    StorekeeperTransaction.create!(
      transaction_id: "TRANS00#{i+1}",
      supplier_id: Supplier.first.id,
      date: Date.today - rand(1..30),
      time: Time.now - rand(60*60*24),
      item: "Item #{i+1}",
      quantity: rand(1..100),
      unit: 'kg'
    )
  end
end

# Create sample tables
Table.destroy_all
5.times do |i|
  Table.create!(
    table_number: i + 1,
    status: 'available'
  )
end

puts "Created #{Table.count} tables"