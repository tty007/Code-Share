class Like < ApplicationRecord
  belongs_to :user
  belongs_to :code

  counter_culture :code

  validates :user_id, presence: true
  validates :code_id, presence: true
end
