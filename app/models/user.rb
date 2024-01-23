class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  enum role: [:job_seeker, :job_recruiter]
  #has_many :JobSeekers
  #has_many :JobRecruiters
  validates :role, presence: true
  validates :role, inclusion: { in: roles.keys } # Ensures the role is one of the defined enum values


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :job_recruiter
  has_one :job_seeker
  has_many :posts
  has_many :comments

  #ROLES = %w{job_seeker job_recruiter}

  def jwt_payload
    super
  end

  #ROLES.each do |role_name|
  #  define_method "#{role_name}?" do
  #     role == role_name
  #  end
  #end


end