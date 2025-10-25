class User < ApplicationRecord
  has_many :jobs
  
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
end
