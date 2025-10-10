class Job < ApplicationRecord
  belongs_to :user
  belongs_to :week

  validates :user_id, uniqueness: {scope: :week_id}
  validates :time1, :time2, :time3, :time4, :time5, :time6, :time7, :comment,
    presence: true, if: -> { [time1,time2,time3,time4,time5,time6,time7,comment].all?(&:blank?) }

end
