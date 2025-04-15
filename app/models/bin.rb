require "rqrcode"

class Bin < ApplicationRecord
  belongs_to :user, counter_cache: true # counter cache for bin counts
  belongs_to :location, optional: true
  has_many :items, dependent: :destroy
  has_many :shared_bins, dependent: :destroy
  has_many :shared_with_users, through: :shared_bins, source: :shared_with
  has_one_attached :bin_picture, dependent: :destroy 
  #has_one_attached :picture
  after_create :update_qr_code
  before_destroy :unassign_all_items

  validates :name, presence: true
  validates :user_id, presence: true
  validates :category_name, presence: true
  
  # Scope to search bins by name or category
  scope :search_by_name, ->(name) { where("name LIKE ?", "%#{name}%") if name.present? }

  def accessible_by?(user)
    return true if user_id == user.id
    return false unless is_shared
    shared_with_users.include?(user)
  end
  
  def items_for_sale
    items.where(for_sale: true)
  end
  
  def items_not_for_sale
    items.where(for_sale: false)
  end

  # query for items in bin, it will be use in bin/show view
  def items_in_bin
    Item.where(bin_id: self.id) # query item belonging to this bin
  end

  def share_with(user)
    return false unless is_shared
    shared_bins.create(shared_with: user)
  end

  def unshare_with(user)
    shared_bins.where(shared_with: user).destroy_all
  end

  private

  def unassign_all_items
    items.find_each(&:safe_destroy)
  end

  # function to update the qr code after create bin object
  def update_qr_code
    self.update_column(:qr_code, generate_qr_code) # update after saving
  end

  def qr_code_data
    # Simple URL format for NFC compatibility
    "http://localhost:3000/bins/#{id}"
  end

  # this function generate the qr code
  def generate_qr_code
    qr = RQRCode::QRCode.new(qr_code_data)
    qr.as_svg(
      module_size: 4,
      standalone: true
    )
  end

end
