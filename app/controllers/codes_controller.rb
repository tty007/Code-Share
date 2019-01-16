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

  def ranking
    #groupメソッドでcode_idが同じものをグループに分ける
    @rank = Note.find(Like.group(:code_id).order('count(code_id) desc').limit(5).pluck(:code_id))
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
      #ファイルが存在すれば削除
      if FileTest.exists?("#{Rails.root}/public/ogp/#{@code.image_url}")
        FileUtils.rm("#{Rails.root}/public/ogp/#{@code.image_url}")
        @code.image_url = nil
      else
        #なければnilを格納のみ
        @code.image_url = nil
      end
    end

    @code.update_attributes(code_params)
    # 新たに画像を生成
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
      #ファイルが存在すれば削除
      if FileTest.exists?("#{Rails.root}/public/ogp/#{@code.image_url}")
        FileUtils.rm("#{Rails.root}/public/ogp/#{@code.image_url}")
      end
    end
    #@codeインスタンスを削除する
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

  #.piblic/ogp/ランダムな文字列.pngというファイル名に加工し、そのPATHを返す
  def uniq_file_name
    "#{SecureRandom.hex}.png"
  end

  #20文字ごとに改行を入れる
  def cut_text(text)
      text.scan(/.{1,20}/).join("\n")
  end

  def create_ogp(code)
    #テキストを書き込みための画像を読み込む
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

    #定義したuniq_file_nameメソッドの処理結果のファイル名をimage_pathに代入
    image_path = image.write("./public/ogp/#{uniq_file_name}").filename

    #定義したcut_textメソッド処理の結果をimage_urlを代入
    image_url = cut_path(image_path)

    #@codeに作成画像であるimage_urlを追加
    code.image_url = image_url

    #S3に画像をアップロード
    uploader = ImageUploader.new
    uploader.store!(image_url)

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
