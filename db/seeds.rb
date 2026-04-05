# Seed data for Avi Lace Studio

puts "Creating admin user..."
admin_password = ENV.fetch("ADMIN_SEED_PASSWORD") { SecureRandom.alphanumeric(20) }
admin_created  = false
admin = User.find_or_create_by!(email: "admin@avilacestudio.com") do |u|
  u.name     = "Admin"
  u.password = admin_password
  u.role     = :admin
  admin_created = true
end
if admin_created
  puts "Admin created: #{admin.email}"
  puts "Admin password: #{admin_password}  *** Save this — it will not be shown again ***"
else
  puts "Admin already exists: #{admin.email}"
end

puts "Creating categories..."
categories = [
  { name: "Cotton Laces",     description: "Soft and breathable cotton laces for daily wear and ethnic garments." },
  { name: "Net Laces",        description: "Delicate net laces perfect for bridal and party wear." },
  { name: "Silk Trims",       description: "Luxurious silk trims for sarees and lehengas." },
  { name: "Embroidered Lace", description: "Beautifully embroidered laces with floral and geometric patterns." },
  { name: "Border Trims",     description: "Wide and narrow border trims for dupattas and sarees." },
  { name: "Ribbon Laces",     description: "Colorful ribbon laces for garment embellishment." },
]

category_records = categories.map do |attrs|
  Category.find_or_create_by!(name: attrs[:name]) do |c|
    c.description = attrs[:description]
  end
end

puts "Creating sample products..."
sample_products = [
  { name: "White Cotton Crochet Lace 2 inch", price: 45.00, compare_price: 65.00, stock_quantity: 250, featured: true,  description: "Classic white cotton crochet lace, 2 inch width. Sold per meter. Ideal for kurtas and ethnic wear." },
  { name: "Cream Net Lace Trim 3 inch",       price: 85.00, compare_price: nil,   stock_quantity: 180, featured: true,  description: "Elegant cream net lace trim, 3 inch width. Perfect for bridal dupatta borders." },
  { name: "Golden Silk Border Trim 1.5 inch", price: 120.00, compare_price: 150.00, stock_quantity: 95, featured: true, description: "Rich golden silk border trim with intricate weave. 1.5 inch width, sold per meter." },
  { name: "Pink Embroidered Lace 4 inch",     price: 95.00, compare_price: nil,   stock_quantity: 140, featured: false, description: "Beautiful pink embroidered lace with floral motifs. 4 inch width." },
  { name: "Blue Border Trim 2 inch",          price: 55.00, compare_price: 70.00, stock_quantity: 200, featured: false, description: "Classic blue border trim for dupattas and salwar suits. 2 inch width." },
  { name: "Red Ribbon Lace 1 inch",           price: 30.00, compare_price: nil,   stock_quantity: 300, featured: false, description: "Vibrant red ribbon lace, 1 inch width. Great for decorative accents." },
  { name: "Silver Zari Lace 2.5 inch",        price: 110.00, compare_price: 140.00, stock_quantity: 75, featured: true, description: "Shimmering silver zari lace for festival and bridal wear. 2.5 inch width." },
  { name: "Off White Crochet Border 3 inch",  price: 60.00, compare_price: nil,   stock_quantity: 160, featured: false, description: "Handcrafted off-white crochet border lace. 3 inch width, per meter." },
]

sample_products.each_with_index do |attrs, i|
  cat = category_records[i % category_records.length]
  Product.find_or_create_by!(name: attrs[:name]) do |p|
    p.price          = attrs[:price]
    p.compare_price  = attrs[:compare_price]
    p.stock_quantity = attrs[:stock_quantity]
    p.featured       = attrs[:featured]
    p.description    = attrs[:description]
    p.category       = cat
    p.status         = :active
    p.sku            = "ALS-#{format('%04d', i + 1)}"
  end
end

puts "Done! #{Category.count} categories, #{Product.count} products, #{User.count} users."
puts "Run the server: bin/rails server"
