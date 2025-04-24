class Log < ApplicationRecord
  belongs_to :user
  belongs_to :item, optional: true
  belongs_to :bin, optional: true

  validates :action_type, presence: true
  validates :action_date, presence: true

  scope :date_range, ->(start_date, end_date) {
    where(action_date: start_date.beginning_of_day..end_date.end_of_day)
  }

  def self.log_item_action(user, item, action_type, description = nil)
    create!(
      user: user,
      item: item,
      bin: item.bin,
      action_type: action_type,
      action_date: Time.current,
      from_location: action_type == 'update' ? item.location_id_was&.to_s : nil,
      to_location: action_type == 'update' ? item.location_id&.to_s : item.location_id&.to_s,
      description: description
    )
  end

  def self.log_bin_action(user, bin, action_type, description = nil)
    create!(
      user: user,
      bin: bin,
      action_type: action_type,
      action_date: Time.current,
      from_location: action_type == 'update' ? bin.location_id_was&.to_s : nil,
      to_location: action_type == 'update' ? bin.location_id&.to_s : bin.location_id&.to_s,
      description: description
    )
  end
end
