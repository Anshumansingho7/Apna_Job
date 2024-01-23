class CreateJobSeekers < ActiveRecord::Migration[7.1]
  def change
    create_table :job_seekers do |t|
      t.string :name
      t.string :qualification
      t.string :skills
      t.string :hobbies
      t.string :address
      t.string :phone_no
      t.string :experience
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
