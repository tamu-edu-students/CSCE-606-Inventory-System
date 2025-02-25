class Session < ApplicationRecord
  belongs_to :user
  serialize :movements, coder: JSON  # ✅ Ensure JSON serialization

  scope :within_dates, ->(date_range) { where(login_time: date_range) }

  def log_movement(action, item)
    ensure_movements_array  # ✅ Ensure movements is an array before appending
    self.movements << { action: action, item_name: item.name, timestamp: Time.current }
    save!
  end

  private

  def ensure_movements_array
    self.movements ||= []
  end
end
