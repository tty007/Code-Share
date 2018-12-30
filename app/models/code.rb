# == Schema Information
#
# Table name: codes
#
#  id          :integer          not null, primary key
#  filename    :string
#  description :string
#  body        :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  uuid        :string           default("b6bae27f-92f1-4523-875d-34e5f528f6ea"), not null
#  image_url   :string
#  likes_count :integer
#

class Code < ApplicationRecord
  #バリデーション
  validates :filename, presence: true

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  # params[:id]にあたるスラッグをuuidに変更
  # Code.friendly.find(params[:id])のように検索
  extend FriendlyId
  friendly_id :uuid

  # 現在のユーザーがいいねしてたらtrueを返す
  def like?(user)
    like_users.include?(user)
  end

  # codeをいいねする
  def like(user, code)
    likes.create(user_id: user.id, code_id: code.id)
  end

  # codeのいいねを解除する
  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end
end
