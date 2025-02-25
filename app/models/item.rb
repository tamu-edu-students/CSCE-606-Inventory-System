class Item < ApplicationRecord
  belongs_to :bin, optional: true
  has_many_attached :item_pictures, dependent: :destroy
  
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
    # Add an error message that will be available in the flash
    errors.add(:base, "Item was unassigned instead of deleted")
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

  def log_creation
    log_movement("created")
  end

  def log_update
    log_movement("updated")
  end

  def log_deletion
    log_movement("deleted")
  end

  def log_movement(action)
    return unless user.sessions.last  # Ensure session exists

    user.sessions.last.log_movement(action, self)
  end
end
