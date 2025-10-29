class User < ApplicationRecord
  has_many :jobs, dependent: :destroy

  enum status: { beginner: 0, active: 1, inactive: 2, retired: 3 }
  
  def full_name
    if middle_name.present?
      "#{last_name}・#{middle_name}・#{first_name}"
    else 
      "#{last_name} #{first_name} "
    end
  end  
  
  def job_for(jobs)
    if jobs[id].present?
      jobs[id].first
    else
      [].first
    end
  end

  def fixed_shift_blank?
    [time1, time2, time3, time4, time5, time6, time7, comment].all?(&:blank?)
  end
end
