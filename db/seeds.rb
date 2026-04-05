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
    
# Products keyed by subcategory name — 2 per subcategory
products_by_category = {
  # LACES
  "Cotton Laces" => [
    { name: "White Cotton Crochet Lace 2 inch",    price: 45.00,  compare_price: 65.00,  stock_quantity: 250, featured: true,  description: "Classic white cotton crochet lace, 2 inch width. Sold per meter. Ideal for kurtas and ethnic wear." },
    { name: "Ivory Cotton Torchon Lace 1.5 inch",  price: 38.00,  compare_price: nil,    stock_quantity: 180, featured: false, description: "Soft ivory cotton torchon lace, 1.5 inch width. Great for casual and ethnic garments." },
  ],
  "Net Laces" => [
    { name: "Cream Net Lace Trim 3 inch",          price: 85.00,  compare_price: nil,    stock_quantity: 180, featured: true,  description: "Elegant cream net lace trim, 3 inch width. Perfect for bridal dupatta borders." },
    { name: "Black Net Scallop Lace 2 inch",       price: 75.00,  compare_price: 95.00,  stock_quantity: 120, featured: false, description: "Delicate black net lace with scallop edge. 2 inch width, per meter." },
  ],
  "Silk Trims" => [
    { name: "Golden Silk Border Trim 1.5 inch",    price: 120.00, compare_price: 150.00, stock_quantity: 95,  featured: true,  description: "Rich golden silk border trim with intricate weave. 1.5 inch width, sold per meter." },
    { name: "Royal Blue Silk Ribbon Trim 1 inch",  price: 95.00,  compare_price: nil,    stock_quantity: 110, featured: false, description: "Luxurious royal blue silk ribbon trim for sarees and lehengas." },
  ],
  "Embroidered Lace" => [
    { name: "Pink Embroidered Lace 4 inch",        price: 95.00,  compare_price: nil,    stock_quantity: 140, featured: false, description: "Beautiful pink embroidered lace with floral motifs. 4 inch width." },
    { name: "Gold Thread Embroidered Border 3 inch", price: 135.00, compare_price: 160.00, stock_quantity: 80, featured: true, description: "Intricate gold thread embroidered border lace. 3 inch width, per meter." },
  ],
  "Border Trims" => [
    { name: "Blue Border Trim 2 inch",             price: 55.00,  compare_price: 70.00,  stock_quantity: 200, featured: false, description: "Classic blue border trim for dupattas and salwar suits. 2 inch width." },
    { name: "Maroon Zari Border Trim 1 inch",      price: 65.00,  compare_price: nil,    stock_quantity: 160, featured: false, description: "Rich maroon zari border trim for ethnic wear. 1 inch width." },
  ],
  "Ribbon Laces" => [
    { name: "Red Ribbon Lace 1 inch",              price: 30.00,  compare_price: nil,    stock_quantity: 300, featured: false, description: "Vibrant red ribbon lace, 1 inch width. Great for decorative accents." },
    { name: "Pastel Pink Satin Ribbon 0.5 inch",   price: 22.00,  compare_price: nil,    stock_quantity: 350, featured: false, description: "Soft pastel pink satin ribbon for garment and gift embellishments." },
  ],
  "Beaded Laces" => [
    { name: "Silver Beaded Border Lace 2 inch",    price: 149.00, compare_price: 180.00, stock_quantity: 90,  featured: true,  description: "Elegant silver beaded border lace for bridal and festive wear. 2 inch width." },
    { name: "Golden Pearl Beaded Trim 1.5 inch",   price: 129.00, compare_price: nil,    stock_quantity: 75,  featured: false, description: "Delicate golden pearl beaded trim, perfect for necklines and dupattas." },
  ],
  "Chain Laces" => [
    { name: "Shiny Gold Curb Chain Lace 1 inch",   price: 199.00, compare_price: 240.00, stock_quantity: 60,  featured: true,  description: "Elegant shiny gold curb chain lace trim. 1 inch width, sold per meter." },
    { name: "Gunmetal Double Layer Chain Trim",    price: 229.00, compare_price: nil,    stock_quantity: 45,  featured: false, description: "Stylish gunmetal double layer chain trim for contemporary garments." },
  ],
  "Guipure Laces" => [
    { name: "White Guipure Floral Lace 4 inch",    price: 189.00, compare_price: 220.00, stock_quantity: 70,  featured: true,  description: "Heavy white guipure lace with open floral mesh. 4 inch width, per meter." },
    { name: "Ivory Guipure Scallop Lace 3 inch",   price: 165.00, compare_price: nil,    stock_quantity: 85,  featured: false, description: "Ivory guipure scallop edge lace for bridal and formal wear." },
  ],
  "Metal Laces" => [
    { name: "Silver Zari Lace 2.5 inch",           price: 110.00, compare_price: 140.00, stock_quantity: 75,  featured: true,  description: "Shimmering silver zari lace for festival and bridal wear. 2.5 inch width." },
    { name: "Antique Gold Metal Thread Lace 2 inch", price: 125.00, compare_price: nil,  stock_quantity: 65,  featured: false, description: "Antique gold metal thread lace for ethnic and bridal garments." },
  ],
  "Tassel Laces" => [
    { name: "Off White Crochet Border 3 inch",     price: 60.00,  compare_price: nil,    stock_quantity: 160, featured: false, description: "Handcrafted off-white crochet border lace. 3 inch width, per meter." },
    { name: "Black Tassel Fringe Trim 3 inch",     price: 175.00, compare_price: 210.00, stock_quantity: 55,  featured: true,  description: "Stylish black tassel fringe trim for boho and ethnic garments. 3 inch drop." },
  ],
  "Sequins Laces" => [
    { name: "Gold Sequin Border Lace 2 inch",      price: 155.00, compare_price: 190.00, stock_quantity: 80,  featured: true,  description: "Glamorous gold sequin border lace for party and bridal wear. 2 inch width." },
    { name: "Silver Sequin Net Lace 3 inch",       price: 165.00, compare_price: nil,    stock_quantity: 65,  featured: false, description: "Shimmering silver sequin net lace trim. 3 inch width, per meter." },
  ],

  # BROOCHES
  "Animal Brooches" => [
    { name: "Antique Gold Elephant Brooch Pin",    price: 189.00, compare_price: 230.00, stock_quantity: 40,  featured: true,  description: "Detailed antique gold elephant brooch pin. 4cm. Perfect for ethnic wear." },
    { name: "Silver Cat Brooch with Crystal Eyes", price: 149.00, compare_price: nil,    stock_quantity: 55,  featured: false, description: "Charming silver cat brooch with sparkling crystal eyes. 3cm." },
  ],
  "Badge Brooches" => [
    { name: "Black Enamel Badge Brooch Gold Frame", price: 95.00, compare_price: 120.00, stock_quantity: 60,  featured: false, description: "Sleek black enamel badge brooch in gold frame. 5.7cm. For formal wear." },
    { name: "Silver Round Badge Brooch Pin",       price: 85.00,  compare_price: nil,    stock_quantity: 75,  featured: false, description: "Classic silver round badge brooch pin. 4cm diameter. Ideal for coats and blazers." },
  ],
  "Bird Brooches" => [
    { name: "Multicolour Enamel Parrot Brooch",    price: 425.00, compare_price: 500.00, stock_quantity: 25,  featured: true,  description: "Vibrant multicolour enamel parrot brooch in antique brass. 11cm. Statement piece." },
    { name: "Gold Peacock Brooch with Blue Stone", price: 319.00, compare_price: nil,    stock_quantity: 30,  featured: true,  description: "Elegant gold peacock brooch with blue stone detailing. 8cm. For ethnic wear." },
  ],
  "Chain Brooches" => [
    { name: "Gold Chain Drop Brooch Pin",          price: 279.00, compare_price: 330.00, stock_quantity: 35,  featured: false, description: "Decorative gold brooch with hanging chain drops. 10cm. For dupattas and sarees." },
    { name: "Silver Chain Cluster Brooch",         price: 245.00, compare_price: nil,    stock_quantity: 40,  featured: false, description: "Elegant silver cluster brooch with delicate chain accents." },
  ],
  "Collar Brooches" => [
    { name: "Gold Collar Clip Brooch Set",         price: 199.00, compare_price: 240.00, stock_quantity: 50,  featured: false, description: "Matching gold collar clip brooch set. For kurta collars and blazer lapels." },
    { name: "Antique Silver Collar Pin Brooch",    price: 165.00, compare_price: nil,    stock_quantity: 60,  featured: false, description: "Classic antique silver collar pin brooch for shirts and kurtis." },
  ],
  "Diamond Brooches" => [
    { name: "Crystal Crown Diamond Brooch",        price: 279.00, compare_price: 340.00, stock_quantity: 30,  featured: true,  description: "Sparkling crystal crown brooch with diamond-finish stones. 10cm. Bridal wear." },
    { name: "Rose Gold Diamond Floral Brooch",     price: 319.00, compare_price: nil,    stock_quantity: 25,  featured: true,  description: "Stunning rose gold floral brooch with diamond-cut crystal stones. 8cm." },
  ],
  "Enamel Brooches" => [
    { name: "Multicolour Enamel Floral Brooch",    price: 149.00, compare_price: 180.00, stock_quantity: 55,  featured: false, description: "Bright multicolour enamel floral brooch. 5cm. Casual and festive wear." },
    { name: "Navy Blue Enamel Gold Brooch",        price: 129.00, compare_price: nil,    stock_quantity: 65,  featured: false, description: "Elegant navy blue enamel brooch in gold finish. 4.5cm." },
  ],
  "Ethnic Wear Brooches" => [
    { name: "Antique Gold Kundan Brooch Pin",      price: 259.00, compare_price: 310.00, stock_quantity: 35,  featured: true,  description: "Traditional kundan-style antique gold brooch pin for ethnic wear. 6cm." },
    { name: "Silver Oxidised Tribal Brooch",       price: 199.00, compare_price: nil,    stock_quantity: 45,  featured: false, description: "Oxidised silver tribal pattern brooch for ethnic and boho styles. 5cm." },
  ],
  "Flower Brooches" => [
    { name: "Gold Rose Flower Brooch Pin",         price: 169.00, compare_price: 200.00, stock_quantity: 50,  featured: true,  description: "Delicate gold rose flower brooch pin with pearl centre. 5cm." },
    { name: "Pearl Daisy Flower Brooch",           price: 149.00, compare_price: nil,    stock_quantity: 60,  featured: false, description: "Elegant pearl daisy flower brooch in silver finish. 4cm." },
  ],
  "Insect Brooches" => [
    { name: "Gold & Black Bee Brooch Pin",         price: 105.00, compare_price: 130.00, stock_quantity: 70,  featured: false, description: "Stunning black and gold bee insect brooch pin. 2.5cm. Trendy fashion accessory." },
    { name: "Antique Gold Butterfly Brooch",       price: 189.00, compare_price: nil,    stock_quantity: 45,  featured: true,  description: "Beautiful antique gold butterfly brooch with crystal wings. 6cm." },
  ],
  "Metal Brooches" => [
    { name: "Shiny Gold Round Metal Brooch",       price: 99.00,  compare_price: 125.00, stock_quantity: 80,  featured: false, description: "Classic shiny gold round metal brooch. 4cm. Versatile for all occasions." },
    { name: "Gunmetal Geometric Brooch Pin",       price: 115.00, compare_price: nil,    stock_quantity: 70,  featured: false, description: "Modern gunmetal geometric brooch pin. 5cm. For contemporary styling." },
  ],
  "Pearl Brooches" => [
    { name: "Vintage Pearl Cluster Brooch",        price: 319.00, compare_price: 380.00, stock_quantity: 28,  featured: true,  description: "Luxurious vintage pearl cluster brooch in antique gold. 8cm. Bridal wear." },
    { name: "Single Pearl Drop Brooch Pin",        price: 189.00, compare_price: nil,    stock_quantity: 45,  featured: false, description: "Elegant single pearl drop brooch pin in silver finish. 4cm." },
  ],
  "Vintage Brooches" => [
    { name: "Antique Gold Vintage Cameo Brooch",   price: 349.00, compare_price: 420.00, stock_quantity: 22,  featured: true,  description: "Classic antique gold vintage cameo brooch. 7cm. A timeless statement piece." },
    { name: "Victorian Silver Filigree Brooch",    price: 299.00, compare_price: nil,    stock_quantity: 30,  featured: false, description: "Intricate Victorian-style silver filigree brooch. 6cm." },
  ],

  # BUTTONS
  "Metal Buttons" => [
    { name: "Shiny Gold Loop Metal Button 17mm",   price: 185.00, compare_price: 220.00, stock_quantity: 150, featured: true,  description: "Premium shiny gold loop metal button. 17mm. Pack of 12. For coats and blazers." },
    { name: "Gunmetal Engraved Shank Button 22mm", price: 259.00, compare_price: nil,    stock_quantity: 100, featured: false, description: "Gunmetal engraved shank button. 22mm. Pack of 12. For jackets and ethnic wear." },
  ],
  "Wooden Buttons" => [
    { name: "Natural Coco 4-Hole Round Button 20mm", price: 99.00, compare_price: 130.00, stock_quantity: 200, featured: false, description: "Natural coco shell 4-hole round button. 20mm. Pack of 12. Eco-friendly." },
    { name: "Classic Wooden 2-Hole Button 25mm",   price: 119.00, compare_price: nil,    stock_quantity: 175, featured: false, description: "Classic natural wooden 2-hole button. 25mm. Pack of 12. For jackets and cardigans." },
  ],
  "Pearl Buttons" => [
    { name: "White Pearl 2-Hole Shirt Button 12mm", price: 79.00, compare_price: 99.00,  stock_quantity: 300, featured: false, description: "Glossy white pearlescent 2-hole shirt button. 12mm. Pack of 12." },
    { name: "Cream Pearl 4-Hole Button 15mm",      price: 95.00,  compare_price: nil,    stock_quantity: 250, featured: false, description: "Soft cream pearl 4-hole button. 15mm. Pack of 12. Ideal for kurtis and blouses." },
  ],
  "Engraved Buttons" => [
    { name: "Antique Gold Floral Engraved Button 17mm", price: 299.00, compare_price: 360.00, stock_quantity: 90, featured: true, description: "Antique gold floral engraved shank button. 17mm. Pack of 12. For ethnic jackets." },
    { name: "Silver Heraldic Engraved Button 22mm", price: 349.00, compare_price: nil,   stock_quantity: 70,  featured: false, description: "Silver heraldic crest engraved button. 22mm. Pack of 12. For formal coats." },
  ],
  "Designer Buttons" => [
    { name: "Sparkling Diamond Metal Button 17mm", price: 389.00, compare_price: 450.00, stock_quantity: 60,  featured: true,  description: "Sparkling diamond-finish metal button. 17mm. Pack of 12. For couture garments." },
    { name: "Rose Gold Designer Button 20mm",      price: 359.00, compare_price: nil,    stock_quantity: 75,  featured: false, description: "Elegant rose gold designer button with floral motif. 20mm. Pack of 12." },
  ],
  "Jeans Buttons" => [
    { name: "Shiny Silver Classic Jeans Button 17mm", price: 165.00, compare_price: 199.00, stock_quantity: 200, featured: false, description: "Sturdy shiny silver classic jeans button with rivet. 17mm. Pack of 12 sets." },
    { name: "Matte Black Jeans Button 17mm",       price: 165.00, compare_price: nil,    stock_quantity: 180, featured: false, description: "Matte black metal jeans button with rivet back. 17mm. Pack of 12 sets." },
  ],

  # NECK DESIGNS
  "Beaded Neck Designs" => [
    { name: "Gold Beaded Round Neck Design 28cm",  price: 259.00, compare_price: 310.00, stock_quantity: 45,  featured: true,  description: "Elegant gold beaded round neck design. 28cm. For bridal kurtis and suits." },
    { name: "Multicolour Beaded V-Neck Design",    price: 229.00, compare_price: nil,    stock_quantity: 55,  featured: false, description: "Vibrant multicolour beaded V-neck design for festive ethnic wear." },
  ],
  "Cord Neck Designs" => [
    { name: "Black Cord Knotted Neck Design 30cm", price: 189.00, compare_price: 225.00, stock_quantity: 50,  featured: false, description: "Intricate black cord knotted neck design. 30cm. For contemporary ethnic wear." },
    { name: "Cream Cord Round Neck Embellishment", price: 169.00, compare_price: nil,    stock_quantity: 60,  featured: false, description: "Delicate cream cord round neck embellishment for kurtis and suits." },
  ],
  "Embroidery Neck Designs" => [
    { name: "Gold Zari Embroidery Neck Design",    price: 309.00, compare_price: 370.00, stock_quantity: 35,  featured: true,  description: "Stunning gold zari embroidery neck design for bridal and festive wear." },
    { name: "Multicolour Thread Neck Embroidery",  price: 249.00, compare_price: nil,    stock_quantity: 45,  featured: false, description: "Vibrant multicolour thread embroidered neck design for ethnic suits." },
  ],
  "Handmade Neck Designs" => [
    { name: "Handmade Crochet Neck Patch 22cm",    price: 199.00, compare_price: 240.00, stock_quantity: 40,  featured: false, description: "Handcrafted crochet neck patch. 22cm. Artisan-made for ethnic kurtis." },
    { name: "Hand Embroidered Floral Neck Piece",  price: 279.00, compare_price: nil,    stock_quantity: 30,  featured: true,  description: "Beautifully hand embroidered floral neck piece for ethnic wear." },
  ],
  "Metal Neck Designs" => [
    { name: "Dual Tone Gold Rose Gold Necklace 28cm", price: 139.00, compare_price: 170.00, stock_quantity: 65, featured: true, description: "Elegant dual tone gold with rose gold diamond necklace neckline. 28.5cm." },
    { name: "Layered Silver Ring Necklace 27cm",   price: 309.00, compare_price: nil,    stock_quantity: 40,  featured: false, description: "Stylish layered silver ring necklace neckline. 27.5cm. Contemporary design." },
  ],
  "Tassel Neck Designs" => [
    { name: "Boho Black Tassel Necklace 33cm",     price: 199.00, compare_price: 240.00, stock_quantity: 50,  featured: true,  description: "Boho chic black tassel necklace design. 33cm. For casual and festive wear." },
    { name: "Gold Tassel Drop Neck Design",        price: 229.00, compare_price: nil,    stock_quantity: 40,  featured: false, description: "Elegant gold tassel drop neck design for ethnic and party wear." },
  ],
  "Crochet Neck Designs" => [
    { name: "White Crochet Floral Neck Design",    price: 149.00, compare_price: 180.00, stock_quantity: 55,  featured: false, description: "Delicate white crochet floral neck design for kurtis and casual ethnic wear." },
    { name: "Ivory Crochet Round Neck Patch 20cm", price: 129.00, compare_price: nil,    stock_quantity: 65,  featured: false, description: "Handcrafted ivory crochet round neck patch. 20cm. Ideal for cotton kurtis." },
  ],

  # TOGGLES
  "Coat Toggles" => [
    { name: "Chocolate Brown PU Leather Coat Toggle", price: 229.00, compare_price: 275.00, stock_quantity: 60, featured: true, description: "Rich chocolate brown PU leather coat toggle. 16.5cm x 5cm. Pack of 1." },
    { name: "Black PU Leather Horn Toggle Set",    price: 129.00, compare_price: nil,    stock_quantity: 80,  featured: false, description: "Classic black PU leather horn toggle. 16.5cm x 4.5cm. For coats and jackets." },
  ],
  "Frog Closures" => [
    { name: "Floral Black Braided Frog Closure",   price: 255.00, compare_price: 310.00, stock_quantity: 45,  featured: true,  description: "Designer floral black braided frog closure toggle. 18cm x 11cm. For ethnic wear." },
    { name: "Gold Metallic Frog Closure Fastener", price: 299.00, compare_price: nil,    stock_quantity: 35,  featured: false, description: "Bright gold metallic braided frog closure. For kurtas and ethnic jackets." },
  ],
  "PU Leather Toggles" => [
    { name: "Coat Clasp Gold with Black PU Leather", price: 159.00, compare_price: 199.00, stock_quantity: 70, featured: false, description: "Elegant coat clasp in shiny gold with black PU leather. 15.5cm x 4cm." },
    { name: "Cream PU Leather Horn Toggle 12-pack", price: 699.00, compare_price: nil,   stock_quantity: 30,  featured: false, description: "Cream PU leather horn toggle buttons. Pack of 12. For coats and jackets." },
  ],
  "Wooden Toggle Buttons" => [
    { name: "Fashion Oval 2-Hole Wooden Toggle 50mm", price: 125.00, compare_price: 155.00, stock_quantity: 90, featured: false, description: "Natural oval 2-hole wooden toggle button. 50mm. Pack of 1." },
    { name: "Large Oval Wooden Toggle Button 60mm", price: 149.00, compare_price: nil,   stock_quantity: 75,  featured: false, description: "Large natural oval wooden toggle button. 60mm. For coats and bags." },
  ],

  # ZIPPERS
  "YKK Zippers" => [
    { name: "YKK #5 Gold Zipper 20 inch",          price: 89.00,  compare_price: 110.00, stock_quantity: 150, featured: true,  description: "Genuine YKK #5 gold metal zipper. 20 inch. For jackets, bags, and garments." },
    { name: "YKK #3 Silver Metal Zipper 12 inch",  price: 85.00,  compare_price: nil,    stock_quantity: 180, featured: false, description: "Genuine YKK #3 silver teeth metal zipper. 12 inch. For trousers and garments." },
  ],
  "Metal Zippers" => [
    { name: "Vintage Gunmetal #5 Zipper 8 inch",   price: 99.00,  compare_price: 125.00, stock_quantity: 120, featured: false, description: "Vintage gunmetal finish #5 metal zipper. 8 inch. For jackets and bags." },
    { name: "Antique Brass #5 Open End Zipper 24 inch", price: 115.00, compare_price: nil, stock_quantity: 90, featured: false, description: "Antique brass #5 open end metal zipper. 24 inch. For jackets and coats." },
  ],
  "Nylon Coil Zippers" => [
    { name: "YKK #3 Black Nylon Coil Zipper 9 inch", price: 29.00, compare_price: 40.00, stock_quantity: 400, featured: false, description: "Lightweight YKK #3 black nylon coil zipper. 9 inch. For trousers and garments." },
    { name: "White Nylon Coil Dress Zipper 12 inch", price: 35.00, compare_price: nil,   stock_quantity: 350, featured: false, description: "Fine white nylon coil dress zipper. 12 inch. For skirts and dresses." },
  ],
  "Invisible Zippers" => [
    { name: "YKK #2 Invisible Zipper 22 inch",     price: 95.00,  compare_price: 115.00, stock_quantity: 130, featured: true,  description: "Premium YKK #2 invisible concealed zipper. 22 inch. For clean dress finishes." },
    { name: "Black Invisible Concealed Zipper 18 inch", price: 89.00, compare_price: nil, stock_quantity: 150, featured: false, description: "Black invisible concealed closed-end zipper. 18 inch. For saree blouses and dresses." },
  ],
  "Waterproof Zippers" => [
    { name: "Waterproof #5 Black Zipper 20 inch",  price: 129.00, compare_price: 155.00, stock_quantity: 80,  featured: false, description: "Water-resistant #5 black coil zipper. 20 inch. For outdoor and technical garments." },
    { name: "Waterproof #5 Navy Zipper 16 inch",   price: 119.00, compare_price: nil,    stock_quantity: 90,  featured: false, description: "Water-resistant #5 navy blue zipper. 16 inch. For jackets and bags." },
  ],
  "Designer Zippers" => [
    { name: "Gold Fancy #5 Decorative Zipper 12 inch", price: 149.00, compare_price: 180.00, stock_quantity: 70, featured: true, description: "Fancy gold decorative #5 zipper. 12 inch. For fashion garments and bags." },
    { name: "Rose Gold Designer Zipper 8 inch",    price: 135.00, compare_price: nil,    stock_quantity: 85,  featured: false, description: "Elegant rose gold designer zipper. 8 inch. For couture bags and garments." },
  ],
}

require "open-uri"

sku_counter = Product.count + 1

products_by_category.each do |cat_name, products|
  cat = Category.find_by!(name: cat_name)

  products.each do |attrs|
    product = Product.find_or_create_by!(name: attrs[:name]) do |p|
      p.price          = attrs[:price]
      p.compare_price  = attrs[:compare_price]
      p.stock_quantity = attrs[:stock_quantity]
      p.featured       = attrs[:featured]
      p.description    = attrs[:description]
      p.category       = cat
      p.status         = :active
      p.sku            = "ALS-#{format('%04d', sku_counter)}"
      sku_counter += 1
    end
    puts "  #{product.previously_new_record? ? 'Created' : 'Exists'}: #{product.name}"
  end
end

puts "Done! #{Category.count} categories, #{Product.count} products, #{User.count} users."
puts "Run the server: bin/rails server"
