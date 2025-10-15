class Job < ApplicationRecord
  belongs_to :user
  belongs_to :week

  validates :user_id, uniqueness: {scope: :week_id}
  validates :time1, :time2, :time3, :time4, :time5, :time6, :time7, :comment,
    presence: true, if: -> { [time1,time2,time3,time4,time5,time6,time7,comment].all?(&:blank?) }
  
  after_commit :broadcast_replace_job


  private

  def broadcast_replace_job
    users = User.all
    jobs  = Job.where(week_id: week.id).group_by(&:user_id)

    broadcast_replace_to(
      "weeks",
      target: "week_content_#{week.id}",
      partial: "public/jobs/broadcast",
      locals: { week: week, users: users, jobs: jobs }
    )
  end
end
