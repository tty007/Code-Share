module ApplicationHelper

  #redcarpetとcoderayを使用するためのヘリパーメソッドを定義
  require "redcarpet"
  require "coderay"

  class HTMLwithCoderay < Redcarpet::Render::HTML
    def block_code(code, language)
      language = language.split(':')[0]

      case language.to_s
      when 'rb'
        lang = 'ruby'
      when 'yml'
        lang = 'yaml'
      when 'css'
        lang = 'css'
      when 'html'
        lang = 'html'
      when 'js'
        lang = 'javascript'
      when ''
        lang = 'md'
      else
        lang = language
      end

      CodeRay.scan(code, lang).div
    end
  end

  def markdown(text)
    html_render = HTMLwithCoderay.new(filter_html: true, hard_wrap: true)
    options = {
      #<>でなくてもリンク解析をする
      autolink: true,
      space_after_headers: true,
      #単語の中で強調を解析しない
      no_intra_emphasis: true,
      # fenceコードブロック、PHP-Markdownスタイルを解析
      # ~インデントされていない3つ以上のブロックまたはバッククォートで区切られたブロックは、コードとみなされる。
      # コードブロックのオープニングフェンスの終わりにオプションの言語名を追加することができる。
      fenced_code_blocks: true,
      #解析テーブル
      tables: true,
      #元のMarkdown文書に改行があった段落内にHTMLタグを挿入
      hard_wrap: true,
      # XHTML準拠のタグを出力
      xhtml: true,
      lax_html_blocks: true,
      strikethrough: true
    }
    markdown = Redcarpet::Markdown.new(html_render, options)
    markdown.render(text)
  end
end
