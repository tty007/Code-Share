class LikesController < ApplicationController
  before_action :authenticate

  def create
    @code = Code.friendly.find(params[:code_id])
    unless @code.like?(current_user)
      @code.like(current_user)
      @code.reload
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end

  def destroy
    @code = Like.find(params[:id]).code
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
