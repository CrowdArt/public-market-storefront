module AssetsHelper
  def asset_exists?(path)
    Rails.application.assets_manifest.find(path).any?
  end
end
