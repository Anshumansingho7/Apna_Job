class CreateJobApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :job_applications do |t|
      t.string :name
      t.string :qualification
      t.string :skills
      t.string :address
      t.string :phone_no
      t.string :experience
      t.references :job_recruiter, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
  end
end
