class SharedBin < ApplicationRecord
  belongs_to :bin
  belongs_to :shared_with, class_name: 'User'
  
  validates :bin_id, uniqueness: { scope: :shared_with_id }
  validate :not_self_share
  
  private
  
  def not_self_share
    errors.add(:shared_with_id, "can't be the same as bin owner") if bin.user_id == shared_with_id
  end
end 