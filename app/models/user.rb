class User < ApplicationRecord
  def full_name
    if middle_name.present?
      "#{first_name}・#{middle_name}・#{last_name}"
    else 
      "#{first_name} #{last_name}"
    end
  end
end
