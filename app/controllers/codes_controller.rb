class CodesController < ApplicationController
  def index
    @codes = Code.all
  end

  def show
    #frendly_idで実装する
    @code = Code.friendly.find(params[:id])
  end

  def new
    @code = current_user.codes.build
  end

  def create
    @code = current_user.codes.build(code_params)
    #uuidを生成する
    @code.uuid = SecureRandom.uuid
    if @code.save
      flash[:notice] = "コードを作成しました"
      redirect_to :action => 'index'
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
    if @code.update(code_params)
      redirect_to :action => 'show'
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

  def code_params
    params.require(:code).permit(%i(filename description body))
  end
end
