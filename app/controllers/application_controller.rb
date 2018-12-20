class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #どのviewからでも参照できるヘルパーメソッドを定義
  helper_method :current_user, :logged_in?

  private

  def current_user
    #sessionがなければメソッドを終了する
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    #sessionがあるかどうかを確認する
    !!session[:user_id]
  end

  def authenticate
    return if logged_in?
    #sessionがなければルートにリダイレクト
    redirect_to root_path, alert: "ログインしてください"
  end

end
