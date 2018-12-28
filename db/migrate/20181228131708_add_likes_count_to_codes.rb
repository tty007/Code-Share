class AddLikesCountToCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :codes, :likes_count, :integer
  end
end
