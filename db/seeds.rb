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

# Main categories with their subcategories
category_tree = {
  "Laces" => {
    description: "All types of laces and trims for garments and accessories.",
    subcategories: [
      { name: "Cotton Laces",     description: "Soft and breathable cotton laces for daily wear and ethnic garments." },
      { name: "Net Laces",        description: "Delicate net laces perfect for bridal and party wear." },
      { name: "Silk Trims",       description: "Luxurious silk trims for sarees and lehengas." },
      { name: "Embroidered Lace", description: "Beautifully embroidered laces with floral and geometric patterns." },
      { name: "Border Trims",     description: "Wide and narrow border trims for dupattas and sarees." },
      { name: "Ribbon Laces",     description: "Colorful ribbon laces for garment embellishment." },
      { name: "Beaded Laces",     description: "Laces adorned with beads for a decorative finish." },
      { name: "Chain Laces",      description: "Metal chain laces for contemporary and ethnic garments." },
      { name: "Guipure Laces",    description: "Heavy corded laces with open mesh patterns." },
      { name: "Metal Laces",      description: "Laces with metallic threads for festive and bridal wear." },
      { name: "Tassel Laces",     description: "Laces with hanging tassels for decorative borders." },
      { name: "Sequins Laces",    description: "Laces embellished with sequins for glamorous looks." },
    ]
  },
  "Brooches" => {
    description: "Decorative pins and brooches for garments and accessories.",
    subcategories: [
      { name: "Animal Brooches",     description: "Brooches shaped like animals for a playful look." },
      { name: "Badge Brooches",      description: "Badge-style brooches for formal and casual wear." },
      { name: "Bird Brooches",       description: "Elegant bird-shaped brooches in metal and enamel." },
      { name: "Chain Brooches",      description: "Brooches with decorative chain accents." },
      { name: "Collar Brooches",     description: "Brooches designed for collar and neckline detailing." },
      { name: "Diamond Brooches",    description: "Crystal and diamond-finish brooches for bridal and party wear." },
      { name: "Enamel Brooches",     description: "Colourful enamel brooches in various designs." },
      { name: "Ethnic Wear Brooches",description: "Traditional brooches suited for ethnic Indian wear." },
      { name: "Flower Brooches",     description: "Floral brooches in metal, pearl, and fabric." },
      { name: "Insect Brooches",     description: "Detailed insect-shaped brooches including butterflies and bees." },
      { name: "Metal Brooches",      description: "Classic metal brooches in gold, silver, and antique finishes." },
      { name: "Pearl Brooches",      description: "Brooches featuring pearl accents for elegant styling." },
      { name: "Vintage Brooches",    description: "Vintage-inspired brooches with antique detailing." },
    ]
  },
  "Buttons" => {
    description: "A wide range of buttons in metal, wood, pearl, and designer styles.",
    subcategories: [
      { name: "Metal Buttons",     description: "Durable metal buttons in gold, silver, gunmetal, and antique finishes." },
      { name: "Wooden Buttons",    description: "Natural and classic wooden buttons including coco shell styles." },
      { name: "Pearl Buttons",     description: "Glossy pearlescent shirt buttons in various sizes." },
      { name: "Engraved Buttons",  description: "Metal buttons with engraved patterns and designs." },
      { name: "Designer Buttons",  description: "Fancy designer buttons for couture and fashion garments." },
      { name: "Jeans Buttons",     description: "Sturdy metal jeans buttons and rivets for denim wear." },
    ]
  },
  "Neck Designs" => {
    description: "Ready-made neckline embellishments for suits, kurtis, and ethnic wear.",
    subcategories: [
      { name: "Beaded Neck Designs",     description: "Necklines adorned with beads for festive and bridal wear." },
      { name: "Cord Neck Designs",       description: "Cord-work necklines with intricate knotting patterns." },
      { name: "Embroidery Neck Designs", description: "Hand and machine embroidered necklines for ethnic garments." },
      { name: "Handmade Neck Designs",   description: "Handcrafted necklines with artisan detailing." },
      { name: "Metal Neck Designs",      description: "Metal plate and chain necklines for contemporary styles." },
      { name: "Tassel Neck Designs",     description: "Necklines featuring tassel accents for a boho look." },
      { name: "Crochet Neck Designs",    description: "Delicate crochet necklines for casual and ethnic wear." },
    ]
  },
  "Toggles" => {
    description: "Coat toggles, frog closures, and toggle buttons for outerwear and ethnic garments.",
    subcategories: [
      { name: "Coat Toggles",        description: "Traditional horn and leather coat toggles for jackets and coats." },
      { name: "Frog Closures",       description: "Decorative braided frog closure fastenings for ethnic wear." },
      { name: "PU Leather Toggles",  description: "PU leather toggle buttons for coats and jackets." },
      { name: "Wooden Toggle Buttons", description: "Oval wooden toggle buttons in natural and lacquered finishes." },
    ]
  },
  "Zippers" => {
    description: "Quality zippers for garments, bags, and accessories.",
    subcategories: [
      { name: "YKK Zippers",         description: "Genuine YKK brand zippers in #2, #3, and #5 sizes." },
      { name: "Metal Zippers",       description: "Metal tooth zippers in gold, silver, and gunmetal finishes." },
      { name: "Nylon Coil Zippers",  description: "Lightweight nylon coil zippers for garments and bags." },
      { name: "Invisible Zippers",   description: "Concealed invisible zippers for clean garment finishes." },
      { name: "Waterproof Zippers",  description: "Water-resistant zippers for outdoor and technical garments." },
      { name: "Designer Zippers",    description: "Fancy decorative zippers for fashion garments and accessories." },
    ]
  },
}

category_records = []

category_tree.each do |parent_name, data|
  parent = Category.find_or_create_by!(name: parent_name) do |c|
    c.description = data[:description]
  end

  data[:subcategories].each do |sub|
    record = Category.find_or_create_by!(name: sub[:name]) do |c|
      c.description = sub[:description]
      c.parent      = parent
    end
    category_records << record
  end
end

puts "  #{Category.count} categories created (#{category_tree.keys.count} parent, #{category_records.count} sub)"

puts "Creating sample products..."

# Dummy lace images sourced from lacesandtrimsbysfindia.com (via Fynd CDN)
lace_image_urls = [
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/RDO4uqMQw-product.jpeg",
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/KFuWPx_te-product.jpeg",
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/Y9g8bW88D-product.jpeg",
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/Rp7GcCW28-product.jpeg",
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/YCg9nV8s6e-product.jpeg",
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/a-ZfxwntM-product.jpeg",
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/oHXwEtRVr-product.jpeg",
  "https://cdn.fynd.com/v2/falling-surf-7c8bb8/fyprod/wrkr/products/pictures/item/free/original/oR90S4VtK-product.jpeg",
]

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

require "open-uri"

sample_products.each_with_index do |attrs, i|
  cat = category_records[i % category_records.length]
  product = Product.find_or_create_by!(name: attrs[:name]) do |p|
    p.price          = attrs[:price]
    p.compare_price  = attrs[:compare_price]
    p.stock_quantity = attrs[:stock_quantity]
    p.featured       = attrs[:featured]
    p.description    = attrs[:description]
    p.category       = cat
    p.status         = :active
    p.sku            = "ALS-#{format('%04d', i + 1)}"
  end

  if product.main_image.blank?
    image_url = lace_image_urls[i % lace_image_urls.length]
    begin
      downloaded = URI.open(image_url, "User-Agent" => "Mozilla/5.0")
      filename   = "lace_#{i + 1}.jpg"
      product.main_image.attach(io: downloaded, filename: filename, content_type: "image/jpeg")
      puts "  Attached image to: #{product.name}"
    rescue => e
      puts "  Could not attach image to #{product.name}: #{e.message}"
    end
  end
end

puts "Done! #{Category.count} categories, #{Product.count} products, #{User.count} users."
puts "Run the server: bin/rails server"
