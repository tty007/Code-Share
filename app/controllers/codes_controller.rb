class CodesController < ApplicationController
  require "fileutils"

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
      FileUtils.rm("#{Rails.root}/public/ogp/#{@code.image_url}")
    end

    @code.destroy
    redirect_to :action => 'index'
  end

  private

  def code_params
    params.require(:code).permit(%i(filename description body))
  end

   #/./public/以下を""に切り取る
   def cut_path(url)
    url.sub(/\.\/public\/ogp\//, "")
  end

  #.piblic/ランダムな文字列/.pngというファイル名に加工する
  def uniq_file_name
    "./public/ogp/#{SecureRandom.hex}.png"
  end

  #20文字ごとに改行を入れる
  def cut_text(text)
      text.scan(/.{1,20}/).join("\n")
  end

  def create_ogp(code)
    #テキストを書き込みための画像を読み込む（4章でpublickフォルダに追加した画像）
    image = Magick::ImageList.new('./public/images/twitter-ogp.png')
    #画像に線や文字を描画するDrawオブジェクトの生成
    draw = Magick::Draw.new
    #cut_textの処理結果をtitleに代入
    title = cut_text(code.filename)

    #文字の描画（引数は、画像、幅、高さ、X座標、Y座標、描画する文字）
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

    #下に定義したuniq_file_nameメソッドの処理結果のファイル名をimage_pathに代入
    image_path = image.write(uniq_file_name).filename
    #下に定義したcut_textメソッド処理の結果をimage_urlを代入
    image_url = cut_path(image_path)
    #@jobに作成画像であるimage_urlを追加
    code.image_url = image_url
  end
end
