class AddColumnToCode < ActiveRecord::Migration[5.2]
  def change
    add_column :codes, :uuid, :string, unique: true, null: false, default: "#{SecureRandom.uuid}"
  end
end
