class AddColumnToCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :codes, :image_url, :string
  end
end
