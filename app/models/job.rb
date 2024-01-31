class Job < ApplicationRecord
  belongs_to :job_recruiter
  validates :field, presence: true
  has_many :job_applications, dependent: :destroy
  has_many :job_applied, dependent: :destroy
  def self.search(search)
    if search
      jcolumns = Job.column_names
      conditions = jcolumns.map { |col| "#{col} LIKE :pattern" }.join(" OR ")
      where(conditions, pattern: "#{search}%")
    end
  end
end
