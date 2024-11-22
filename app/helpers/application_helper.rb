module ApplicationHelper
  def default_meta_tags
    {
      site: "PictioDiary",
      title: "PictioDiary",
      reverse: true,
      description: "英文絵日記で楽しく英語学習を",
      keywords: "英語学習,絵日記",
      canonical: request.original_url,
      separator: "|",
      icon: [
        { href: image_url("favicon.ico"), sizes: "60x60" },
        { href: image_url("OGP.png"), rel: "apple-touch-icon", sizes: "90x90", type: "image/png" }
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("OGP.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary",
        site: "@",
        image: image_url("OGP.png")
      }
    }
  end
end
