class MuscleGroup < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :muscles, dependent: :destroy
  has_many :exercises, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
