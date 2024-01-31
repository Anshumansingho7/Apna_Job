class JobSeeker < ApplicationRecord
  belongs_to :user
  validates :name, :qualification, :address, presence: true
  validates :phone_no, presence: true, uniqueness: true 
  has_many :job_applied, dependent: :destroy
  def self.search(search)
    if search
      scolumns = JobSeeker.column_names
      conditions = scolumns.map { |col| "#{col} LIKE :pattern" }.join(" OR ")
      where(conditions, pattern: "#{search}%")
    end
  end
end
