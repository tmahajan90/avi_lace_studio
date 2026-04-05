class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  enum :role, { customer: 0, admin: 1 }

  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wishlist_products, through: :wishlists, source: :product
  has_one :cart, dependent: :destroy

  validates :name, presence: true
end
