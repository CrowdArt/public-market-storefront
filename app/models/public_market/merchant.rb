module PublicMarket
  class Merchant
    include ActiveModel::Model

    attr_accessor :first_name, :last_name, :email, :company_name, :phone,
                  :sku_count, :product_categories, :brand, :website,
                  :marketplaces, :software, :other_category
  end
end
