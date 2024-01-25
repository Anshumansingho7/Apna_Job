class JobSeeker < ApplicationRecord
  belongs_to :user
  validates :name, :qualification, :address, presence: true
  validates :phone_no, presence: true, uniqueness: true 
  has_many :job_applied, dependent: :destroy

end
