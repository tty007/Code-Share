class CreateCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :codes do |t|
      t.string :filename
      t.string :description
      t.text :body
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
