class Removecolumnstopost < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :likes_count, :integer, default: 0
    remove_column :likes, :status, :string
  end
end
