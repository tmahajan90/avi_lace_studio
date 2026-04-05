class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, foreign_key: :shipping_address_id

  enum :address_type, { home: 0, work: 1, other: 2 }

  validates :full_name, :phone, :address_line1, :city, :state, :pincode, presence: true
  validates :pincode, format: { with: /\A[1-9][0-9]{5}\z/, message: "must be a valid 6-digit Indian pincode" }
  validates :phone, format: { with: /\A[6-9]\d{9}\z/, message: "must be a valid 10-digit Indian mobile number" }
end
