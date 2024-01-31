class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  enum role: [:job_seeker, :job_recruiter]
  #has_many :JobSeekers
  #has_many :JobRecruiters
  validates :role, presence: true
  validates :role, inclusion: { in: roles.keys } # Ensures the role is one of the defined enum values


  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :job_recruiter, dependent: :destroy
  has_one :job_seeker, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  #ROLES = %w{job_seeker job_recruiter}

  def update_password_without_current(params)
    update(params)
  end

  def jwt_payload
    super
  end

  #ROLES.each do |role_name|
  #  define_method "#{role_name}?" do
  #     role == role_name
  #  end
  #end


end