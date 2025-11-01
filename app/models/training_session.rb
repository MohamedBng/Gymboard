class TrainingSession < ApplicationRecord
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  before_validation :set_default_name, if: -> { name.blank? }

  has_many :training_session_muscle_groups, dependent: :destroy
  has_many :muscle_groups, through: :training_session_muscle_groups

  private

  def end_time_after_start_time
    return unless start_time && end_time

    if end_time <= start_time
      errors.add(:end_time, :must_be_after_start_time)
    end
  end

  def set_default_name
    return unless start_time

    date_format = start_time.strftime("%B %d")
    self.name = "Session — #{date_format}"
  end
end
