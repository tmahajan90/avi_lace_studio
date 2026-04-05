class ProductImage < ApplicationRecord
  belongs_to :product
  has_one_attached :image

  validates :position, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(:position) }
end
