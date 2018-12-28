class LikesController < ApplicationController
  before_action :authenticate

  def create
    @code = Code.friendly.find(params[:code_id])
    unless @code.like?(current_user)
      @code.like(current_user, @code)
      @code.reload
      respond_to do |format|
        # リファラーとは、該当ページに遷移する直前に閲覧されていた参照元（遷移元・リンク元）ページのURL
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end

  def destroy
    @code = Code.friendly.find(params[:code_id])
    if @code.like?(current_user)
      @code.unlike(current_user)
      @code.reload
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end
end
