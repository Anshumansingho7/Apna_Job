class RenameCompanyNameToNameInJobRecruiters < ActiveRecord::Migration[7.1]
  def change
    rename_column :job_recruiters, :Comapany_name, :name
  end
end
