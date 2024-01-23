class CreateJobRecruiters < ActiveRecord::Migration[7.1]
  def change
    create_table :job_recruiters do |t|
      t.string :Comapany_name
      t.string :Gst_no
      t.string :address
      t.string :phone_no
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
