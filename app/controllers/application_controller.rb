class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :current_user?

  private

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def current_user?(user)
    return unless session[:user_id]
    if user == User.find(session[:user_id])
      true
    end
  end

  def logged_in?
    !!session[:user_id]
  end

  def authenticate
    return if logged_in?
    flash[:notice] = "ログインが必要です"
    redirect_to root_path
  end

end
