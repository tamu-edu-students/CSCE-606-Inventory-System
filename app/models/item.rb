class Item < ApplicationRecord
  belongs_to :user
  belongs_to :bin, optional: true
  belongs_to :location, optional: true
  has_many_attached :item_pictures, dependent: :destroy
  
  validates :name, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_no_bin_status

  after_create :log_creation
  after_update :log_update
  after_destroy :log_deletion

  # Scope for searching items by name
  scope :search_by_name, ->(query) {
  where("LOWER(name) LIKE ?", "%#{query.downcase}%")
}

  def unassigned?
    bin_id.nil? && no_bin?
  end

    # Custom delete handler
    def safe_destroy
      if unassigned?
        destroy
      else
        was_bin_id = bin_id
        was_location = location_id
        update_columns(bin_id: nil, no_bin: true)
        Log.log_item_action(user, self, 'move', "Unassigned from bin ID: #{was_bin_id}")
        false
      end
    end

  private

  def inherit_bin_location
    self.location_id = bin.location_id if bin.present?
  end

  def log_creation
    Log.log_item_action(user, self, 'create', "Created item: #{name}")
  end

  def log_update
    if saved_changes.present?
      changes_desc = saved_changes.except('updated_at').map do |attr, changes|
        "#{attr}: #{changes[0]} → #{changes[1]}"
      end.join(', ')
      Log.log_item_action(user, self, 'update', "Updated: #{changes_desc}")
    end
  end

  def log_deletion
    Log.log_item_action(user, self, 'delete', "Deleted item: #{name}")
  end

  def validate_no_bin_status
    if bin_id.nil? && !no_bin?
      errors.add(:no_bin, "must be true when item is not assigned to a bin")
    elsif bin_id.present? && no_bin?
      errors.add(:no_bin, "must be false when item is assigned to a bin")
    end
  end
end
