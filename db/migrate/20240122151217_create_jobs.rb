class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :experience_required
      t.string :salary
      t.string :field
      t.string :skills_required
      t.references :job_recruiter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
