url_proto = %w[http https].include?(URI.parse(Spree::Store.default.url).scheme) ? '' : 'https://'
SitemapGenerator::Sitemap.default_host = url_proto + Spree::Store.default.url

SitemapGenerator::Sitemap.create do
  add_login
  add_signup
  add_password_reset
  add_taxons

  add(products_path)

  Spree::Product.active.distinct.find_each do |product|
    add(product_path(product), lastmod: product.updated_at)
  end

  Spree::Page.live.find_each do |page|
    add(page.slug, lastmod: page.updated_at)
  end

  Spree::Vendor.find_each do |vendor|
    add(vendor_path(vendor), lastmod: vendor.updated_at)
  end
end
