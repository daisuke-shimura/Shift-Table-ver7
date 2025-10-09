class Job < ApplicationRecord
  belongs_to :user
  belongs_to :week

  def job_for(week)
    jobs.find { |job| job.week_id == week.id }
  end
end
