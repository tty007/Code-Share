class CodesController < ApplicationController

  require "fileutils"

  def index
    @codes = Code.all
  end

  def show
    @code = Code.friendly.find(params[:id])

    # [.png]を削除したurlを取得するためのURL
    # if @code.image_url.present?
    #   @image_url = @code.image_url.sub(/\.png/, '')
    # end
  end

  def ranking
    #groupメソッドでcode_idが同じものをグループに分ける
    @rank = Note.find(Like.group(:code_id).order('count(code_id) desc').limit(5).pluck(:code_id))
  end

  def new
    @code = current_user.codes.build
  end

  def create
    @code = current_user.codes.build(code_params)
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
    if @code.image_url.present?
      if FileTest.exists?("#{Rails.root}/public/ogp/#{@code.image_url}")
        FileUtils.rm("#{Rails.root}/public/ogp/#{@code.image_url}")
      end
    end
    @code.destroy
    redirect_to :action => 'index'
  end

  private

  def code_params
    params.require(:code).permit(%i(filename description body))
  end

  def cut_path(url)
    url.sub(/\.\/public\/ogp\//, "")
  end

  def uniq_file_name
    "#{SecureRandom.hex}.png"
  end

  def cut_text(text)
    #20文字ごとに改行を入れる
    text.scan(/.{1,20}/).join("\n")
  end

  def create_ogp(code)
    image = Magick::ImageList.new('./public/images/twitter-ogp.png')
    draw = Magick::Draw.new
    title = cut_text(code.filename)
    
    draw.annotate(image, 0, 0, 0, -10, title) do
      #日本語対応可能なフォントにする(rootから読み込み)
      self.font = "#{Rails.root}/.fonts/ipag.ttf"
      #フォントの塗りつぶし色
      self.fill = '#fff'
      #描画基準位置(中央)
      self.gravity = Magick::CenterGravity
      #フォントの太さ
      self.font_weight = Magick::BoldWeight
      #フォント縁取り色(透過)
      self.stroke = 'transparent'
      #フォントサイズ
      self.pointsize = 38
    end
    #ローカル保存
    binding.pry
    image_path = image.write("./public/ogp/#{uniq_file_name}").filename
    image_url = cut_path(image_path)
    code.image_url = image_url

    #S3に画像をアップロード
    uploader = ImageUploader.new
    uploader.store!(image.flatten_images.ping)

  end

  # コードにいいねする
  def like(user)
    likes.create(user_id: user.id)
  end

  # コードのいいねを解除する
  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end
end
