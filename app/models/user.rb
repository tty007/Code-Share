# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  provider    :string
#  uid         :string
#  user_name   :string
#  image_url   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class User < ApplicationRecord

  has_many :codes, dependent: :destroy
  has_many :likes, dependent: :destroy

  def self.find_or_create_from_auth(auth)
    #providerはTwitterのはず
    provider = auth[:provider]
    #provider毎に与えられる識別用のユニークid
    uid = auth[:uid]
    #user_nameとimageはさらにinfoのネストになっている
    user_name = auth[:info][:name]
    image_url = auth[:info][:image]
    user_desc = auth[:info][:description]

    # 該当ユーザ有りなら値を更新する
    if e_user = self.find_by(uid: uid)
      e_user.update_attributes(user_name: user_name, image_url: image_url, description: user_desc)
    end

    #該当ユーザ無しなら新規に作成する
    self.find_or_create_by(provider: provider, uid: uid) do |user|
      user.user_name = user_name
      user.image_url = image_url
      user.description = user_desc
    end
  end
  
end
