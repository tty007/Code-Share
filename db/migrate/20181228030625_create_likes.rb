class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id, null: false
      t.integer :code_id, null: false

      t.timestamps

      t.index :user_id
      t.index :code_id
      t.index [:user_id, :code_id], unique: true
    end
  end
end
