class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shipping_address, class_name: "Address", optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :status, { pending: 0, confirmed: 1, processing: 2, shipped: 3, delivered: 4, cancelled: 5 }
  enum :payment_status, { unpaid: 0, paid: 1, refunded: 2 }, prefix: :payment

  before_create :generate_order_number

  def to_param
    order_number
  end

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[order_number status payment_status created_at total_amount]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  def build_from_cart(cart)
    cart.cart_items.each do |item|
      order_items.build(
        product: item.product,
        quantity: item.quantity,
        unit_price: item.price,
        total_price: item.subtotal,
        product_name: item.product.name
      )
    end
    self.subtotal = cart.total
    self.total_amount = subtotal + (shipping_amount || 0)
  end

  private

  def generate_order_number
    loop do
      number = "ALS-#{Time.now.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
      unless Order.exists?(order_number: number)
        self.order_number = number
        break
      end
    end
  end
end
