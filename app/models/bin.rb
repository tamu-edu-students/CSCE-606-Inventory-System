class Bin < ApplicationRecord
  belongs_to :user, counter_cache: true # counter cache for bin counts
  has_many :items # reference to items
  has_many_attached :bin_pictures, dependent: :destroy # bin with multiple pictures

  validates :name, presence: true

  #query for items in bin, it will be use in bin/show view
  def items_in_bin
    Item.where(bin_id: self.id) #query item belonging to this bin
  end
end
