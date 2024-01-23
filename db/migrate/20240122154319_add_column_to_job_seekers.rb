class AddColumnToJobSeekers < ActiveRecord::Migration[7.1]
  def change
    add_column :job_seekers, :job_field, :string
  end
end
