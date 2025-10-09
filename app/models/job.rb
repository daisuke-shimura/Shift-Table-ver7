class Job < ApplicationRecord
  belongs_to :user
  belongs_to :week
end
