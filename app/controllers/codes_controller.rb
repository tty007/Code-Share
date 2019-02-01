class CodesController < ApplicationController
  # ファイルを削除するためのライブラリ
  require "fileutils"

  def index
    @codes = Code.all
  end

  def show
    #frendly_idで実装する
    @code = Code.friendly.find(params[:id])
    #コメントインスタンスを生成
    # @comment = @code.comments.build
    # [.png]を削除したurlを取得するためのURL
    if @code.image_url.present?
      @image_url = @code.image_url.sub(/\.png/, '')
    end
  end

  def new
    @code = current_user.codes.build
  end

  def create
    @code = current_user.codes.build(code_params)
    #uuidを生成する
    @code.uuid = SecureRandom.uuid
    create_ogp(@code)

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
    # @codeに紐づいた画像も一緒に削除
    if @code.image_url.present?
      if FileTest.exists?("#{Rails.root}/public/ogp/#{@code.image_url}")
        FileUtils.rm("#{Rails.root}/public/ogp/#{@code.image_url}")
        @code.image_url = nil
      else
        @code.image_url = nil
      end
    end

    @code.update_attributes(code_params)
    create_ogp(@code)    

    if @code.update(code_params)
      redirect_to code_url(@code)
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = 'コードファイルを削除しました。'
    @code = current_user.codes.friendly.find(params[:id])

    # @codeに紐づいた画像も一緒に削除
    if @code.image_url.present?
      if FileTest.exists?("#{Rails.root}/public/ogp/#{@code.image_url}")
        FileUtils.rm("#{Rails.root}/public/ogp/#{@code.image_url}")
      end
    end
    @code.destroy
    redirect_to :action => 'index'
  end


  def ranking
    #groupメソッドでcode_idが同じものをグループに分ける
    #order('count(id) desc')で、idの数でオーダーを降順でつける（つまり多い順から）
    #pluckでそのカラムのみの情報を取り出し値を返す
    @codes = Code.find(Like.group(:code_id).order('count(code_id) desc').limit(20).pluck(:code_id))
  end

  private

  def code_params
    params.require(:code).permit(%i(filename description body))
  end

  def cut_path(url)
    url.sub(/\.\/public\/ogp\//, "")
  end

  def uniq_file_name
    "./public/ogp/#{SecureRandom.hex}.png"
  end

  def cut_text(text)
      text.scan(/.{1,20}/).join("\n")
  end

  def create_ogp(code)
    image = Magick::ImageList.new('./public/images/twitter-ogp.png')
    draw = Magick::Draw.new
    title = cut_text(code.filename)

    draw.annotate(image, 0, 0, 0, -10, title) do
      self.font = "#{Rails.root}/.fonts/ipag.ttf"
      self.fill = '#fff'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.stroke = 'transparent'
      self.pointsize = 38
    end
    image_path = image.write(uniq_file_name).filename
    image_url = cut_path(image_path)
    code.image_url = image_url
  end

  def like(user)
    likes.create(user_id: user.id)
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end
end
