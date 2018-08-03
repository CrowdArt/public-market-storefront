module PublicMarket
  module Workers
    module Slack
      class DataReconcilationWorker < Slack::NotifierWorker
        private

        def message
          product = Spree::Product.find_by(id: options[:product_id])

          return if product.blank?

          msg_opts = {
            url: spree_url_helpers.edit_admin_product_url(product),
            taxonomy: product.taxonomy.name,
            product_title: product.name
          }

          I18n.t("slack.data-reconcilation.#{options[:message_type]}", msg_opts)
        end

        def channel_name
          :data_reconcilation
        end
      end
    end
  end
end
