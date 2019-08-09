class CodesController < ApplicationController

  def index
    @codes = Code.all
  end

  def show
    @code = Code.friendly.find(params[:id])
    # if @code.image_url.present?
    #   @image_url = @code.image_url.sub(/\.png/, '')
    # end
  end

  def new
    @code = current_user.codes.build
  end

  def create
    @code = current_user.codes.build(code_params)
    @code.uuid = SecureRandom.uuid
    if @code.save
      flash[:notice] = "コードを作成しました"
      redirect_to codes_url
    else
      flash[:notice] = "エラーが発生しました. もう一度保存して下さい。"
      render :new
    end
  end

  def edit
    @code = current_user.codes.friendly.find(params[:id])
  end

  def update
    @code = current_user.codes.friendly.find(params[:id])
    @code.update_attributes(code_params)   
    if @code.update(code_params)
      redirect_to code_url(@code)
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = 'コードファイルを削除しました。'
    @code = current_user.codes.friendly.find(params[:id])
    @code.destroy
    redirect_to :action => 'index'
  end


  def ranking
    @codes = Code.find(Like.group(:code_id).order('count(code_id) desc').limit(20).pluck(:code_id))
  end

    private

  def code_params
    params.require(:code).permit(%i(filename description body image_url))
  end

  def cut_path(url)
    url.sub(/\.\/public\/ogp\//, "")
  end

  def like(user)
    likes.create(user_id: user.id)
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end
end
