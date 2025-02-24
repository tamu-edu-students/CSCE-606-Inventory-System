class Item < ApplicationRecord
  belongs_to :bin, optional: true
  has_one :picture, dependent: :destroy

  validates :name, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_no_bin_status

  before_destroy :prevent_deletion_and_unassign

  def unassigned?
    bin_id.nil? && no_bin?
  end

  private

  def prevent_deletion_and_unassign
    # Instead of allowing destruction, unassign from bin
    self.update(bin_id: nil, no_bin: true)
    # Prevent the actual destruction
    throw :abort
  end

  def validate_no_bin_status
    if bin_id.nil? && !no_bin?
      errors.add(:no_bin, "must be true when item is not assigned to a bin")
    elsif bin_id.present? && no_bin?
      errors.add(:no_bin, "must be false when item is assigned to a bin")
    end
  end
end
