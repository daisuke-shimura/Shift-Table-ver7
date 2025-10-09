class User < ApplicationRecord
  has_many :jobs
  has_many :jobs_for_week, ->(week) { where(week_id: week.id) }, class_name: 'Job'
  
  def full_name
    if middle_name.present?
      "#{first_name}・#{middle_name}・#{last_name}"
    else 
      "#{first_name} #{last_name}"
    end
  end  
  
  # def job_for(week)
  #   
  # end
end
