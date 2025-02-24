class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :bin, optional: true
  belongs_to :item, optional: true

  has_one_attached :image

  validates :image, presence: true
end
