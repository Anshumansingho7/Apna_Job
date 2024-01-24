class AddColumnToApplied < ActiveRecord::Migration[7.1]
  def change
    add_reference :job_applieds, :job_application, foreign_key: true
  end
end
