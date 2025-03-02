module ApplicationHelper
  # デフォルトのmetaタグ
  def default_meta_tags
    {
      site: "お散歩マップ",
      title: "お散歩マップ",
      reverse: true,
      charset: "utf-8",
      description: "散歩コース共有を目的としたアプリです",
      canonical: request.original_url, # サイトの正規url
      separator: "|",
      og: {
        site_name: "お散歩マップ",
        title: "お散歩マップ",
        description: "散歩コース共有を目的としたアプリです",
        type: "website", # ページの種類
        url: request.original_url,
        image: image_url('default_share.png'),
        local: "ja-JP" # 言語と地域
      },
      twitter: {
        card: "summary",
        image: image_url('default_share.png')
      }
    }
  end

  # metaタグを更新するメソッド
  def assign_meta_tags(options = {})
    meta_tags =
      {
        og: {
          title: options[:title].presence || default_meta_tags[:title],
          description: options[:description].presence || default_meta_tags[:description],
          image: options[:image].presence || default_meta_tags[:og][:image]
        },
        twitter: {
          image: options[:image].presence || default_meta_tags[:og][:image]
        }
      }

    set_meta_tags(meta_tags)
  end
end
