class SessionsController < ApplicationController
  def create
    user = User.find_or_create_from_auth(auth_hash)
    if user
      session[:user_id] = user.id
      flash[:notice] = "ユーザー認証が完了しました。"
      redirect_to profile_path
    else
      redirect_to root_path, notice: "失敗しました。"
    end
  end

  def destroy
    #reset_sessionで全てのセッション情報を削除
    reset_session
    flash[:notice] = "ログアウトしました。"
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end