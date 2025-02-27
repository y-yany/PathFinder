module ApplicationHelper
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
        # image: image_url('default_share.png'),
        local: "ja-JP" # 言語と地域
      },
      twitter: {
        card: "summary_large_image",
        # image: image_url('default_share.png')
      }
    }
  end
end
