class Job < ApplicationRecord
  belongs_to :user
  belongs_to :week

  validates :user_id, uniqueness: {scope: :week_id}
  validates :time1, :time2, :time3, :time4, :time5, :time6, :time7, :comment,
    presence: true, if: -> { [time1,time2,time3,time4,time5,time6,time7,comment].all?(&:blank?) }
  
  
  # after_create_commit  :broadcast_jobs_update
  # after_update_commit  :broadcast_jobs_update
  # after_destroy_commit :broadcast_jobs_destroy

  # private
  # def broadcast_jobs_update
  #   users = User.all
  #   jobs  = Job.where(week_id: week_id).group_by(&:user_id)
  #   week.broadcast_replace_to(
  #     "weeks",
  #     target: "week_content_#{week_id}",
  #     partial: "public/jobs/table",
  #     locals: { week: week, users: users, jobs: jobs, login_user: user }
  #   )
  # end

  # def broadcast_jobs_destroy
  #   users = User.all
  #   jobs  = Job.where(week_id: week_id).group_by(&:user_id)
  #   week.broadcast_replace_to(
  #     "weeks",
  #     target: "week_content_#{week_id}",
  #     partial: "public/jobs/table",
  #     locals: { week: week, users: users, jobs: jobs, login_user: user }
  #   )
  # end
end
