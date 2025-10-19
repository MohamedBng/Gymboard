class Exercise < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
