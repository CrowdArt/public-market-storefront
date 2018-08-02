module AssetsHelper
  def asset_exists?(path)
    # https://github.com/rails/sprockets-rails/issues/298#issuecomment-168927471
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include?(path)
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end
