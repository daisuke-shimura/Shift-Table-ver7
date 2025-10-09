class Week < ApplicationRecord
  has_many :jobs

  validate :monday_validate
  validates :monday, presence: true, uniqueness: true

  def monday_validate
    return if monday.blank?
    unless monday.monday?
      errors.add(:monday, 'must be a Monday')
    end
  end

  def sunday
    monday + 6
  end

  def tuesday
    monday + 1
  end

  def wednesday
    monday + 2
  end

  def thursday
    monday + 3
  end

  def friday
    monday + 4
  end

  def saturday
    monday + 5
  end
end
