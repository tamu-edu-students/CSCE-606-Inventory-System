require "rqrcode"

class Bin < ApplicationRecord
  belongs_to :user, counter_cache: true # counter cache for bin counts
  has_many :items # reference to items
  has_many :pictures, dependent: :destroy # bin with multiple pictures
  after_create :update_qr_code

  validates :name, presence: true

  # query for items in bin, it will be use in bin/show view
  def items_in_bin
    Item.where(bin_id: self.id) # query item belonging to this bin
  end

  private

  # function to update the qr code after create bin object
  def update_qr_code
    self.update_column(:qr_code, generate_qr_code) # update after saving
  end

  def qr_code_data
      host = Rails.env.production? ? ENV["APP_HOST"] : "http://127.0.0.1:3000"
      "#{host}/bins/#{self.id}"
  end

  # this function generate the qr code
  def generate_qr_code
    base_url = qr_code_data # Generate URL dynamically
    qr = RQRCode::QRCode.new(base_url) # generate unique QR code data
    qr.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    )
  end
end
