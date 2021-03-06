# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  code_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :code

  counter_culture :code

  validates :user_id, presence: true
  validates :code_id, presence: true
end
