class User < ApplicationRecord

  def self.find_or_create_from_auth(auth)
    #providerはTwitterのはず
    provider = auth[:provider]
    #provider毎に与えられる識別用のユニークid
    uid = auth[:uid]
    #user_nameとimageはさらにinfoのネストになっている
    user_name = auth[:info][:name]
    image_url = auth[:info][:image]

    #該当ユーザ無しなら新規に作成する
    self.find_or_create_by(provider: provider, uid: uid) do |user|
      user.user_name = user_name
      user.image_url = image_url
    end
  end
  
end
