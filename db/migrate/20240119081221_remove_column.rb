class RemoveColumn < ActiveRecord::Migration[7.1]
  def change
  end
end
    remove_column :users, :role, :integer
