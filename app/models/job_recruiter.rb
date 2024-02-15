class JobRecruiter < ApplicationRecord
  belongs_to :user
  has_many :job, dependent: :destroy 
  validates :name, :address, presence: true
  validates :phone_no, :Gst_no, presence: true, uniqueness: true 
  has_many :job_applications, dependent: :destroy
  
  def self.search(search)
    if search
      rcolumns = JobRecruiter.column_names
      conditions = rcolumns.map { |col| "#{col} LIKE :pattern" }.join(" OR ")
      where(conditions, pattern: "#{search}%")
    end
  end
end
