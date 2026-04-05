class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, dependent: :destroy
  has_many :order_items, dependent: :nullify
  has_many :wishlists, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_one_attached :main_image

  enum :status, { draft: 0, active: 1, archived: 2 }

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :slug, presence: true, uniqueness: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_slug

  scope :published, -> { where(status: :active) }
  scope :featured, -> { where(featured: true) }
  scope :in_stock, -> { where("stock_quantity > 0") }

  def self.ransackable_attributes(auth_object = nil)
    %w[name description price compare_price stock_quantity sku status featured created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  def image_url
    cloudinary_url.presence
  end

  def cloudinary_folder
    cat = category
    return "avi_lace_studio/products" unless cat
    if cat.parent.present?
      "avi_lace_studio/#{cat.parent.name.parameterize.underscore}/#{cat.name.parameterize.underscore}"
    else
      "avi_lace_studio/#{cat.name.parameterize.underscore}"
    end
  end

  def in_stock?
    stock_quantity > 0
  end

  def discounted?
    compare_price.present? && compare_price > price
  end

  def discount_percentage
    return 0 unless discounted?
    ((compare_price - price) / compare_price * 100).round
  end

  private

  def set_slug
    self.slug = name.parameterize if name.present? && slug.blank?
  end
end
