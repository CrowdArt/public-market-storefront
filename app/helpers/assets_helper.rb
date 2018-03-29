module AssetsHelper
  def asset_exists?(path)
    Rails.application.assets.resolve(path).present?
  end
end
