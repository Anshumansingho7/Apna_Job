class ChangeRoleDataType < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :role, :string
  end
end
