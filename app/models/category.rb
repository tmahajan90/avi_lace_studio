class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug

  scope :root_categories, -> { where(parent_id: nil) }

  private

  def set_slug
    self.slug = name.parameterize if name.present? && slug.blank?
  end
end
