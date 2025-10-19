class Session < ApplicationRecord
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :title, presence: true

  validate :start_time_before_end_time

  private

  def start_time_before_end_time
    return unless start_time && end_time

    if start_time >= end_time
      errors.add(:end_time, :must_be_after_start_time)
    end
  end
end
