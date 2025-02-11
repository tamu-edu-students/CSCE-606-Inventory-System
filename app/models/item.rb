class Item < ApplicationRecord
  belongs_to :bin
  has_many_attached :item_pictures # Allow multiple pictures

  validates :name, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0}
end
