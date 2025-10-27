class Week < ApplicationRecord
  has_many :jobs, dependent: :destroy

  validate :monday_validate
  validates :monday,
    presence: { message: '日付を入力してください。' },
    uniqueness: { message: '既に作成済みの日程です。' }

  def monday_validate
    return if monday.blank?
    unless monday.monday?
      errors.add(:monday, '月曜日を指定してください。')
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
