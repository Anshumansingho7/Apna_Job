class Addcolumnto < ActiveRecord::Migration[7.1]
  def change
    add_column :likes, :status, :string
  end
end
