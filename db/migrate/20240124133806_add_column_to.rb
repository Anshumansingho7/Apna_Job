class AddColumnTo < ActiveRecord::Migration[7.1]
  def change
    add_column :job_applieds, :status, :string
    add_column :job_applications, :status, :string
  end
end
