class CreateJobApplieds < ActiveRecord::Migration[7.1]
  def change
    create_table :job_applieds do |t|
      t.string :company_name
      t.string :experience_required
      t.string :salary
      t.string :address
      t.string :field
      t.string :skills_required
      t.references :job_seeker, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
  end
end
