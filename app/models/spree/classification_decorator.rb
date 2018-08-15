module Spree
  module ClassificationDecorator
    def self.prepended(base)
      # base.after_create_commit :notify_uncategorized, if: -> { taxon.name == Spree::Taxon::UNCATEGORIZED_NAME }
    end

    def notify_uncategorized
      PublicMarket::Workers::Slack::DataReconcilationWorker.perform_async(product_id: product_id, message_type: 'uncategorized')
    rescue => e # rubocop:disable Style/RescueStandardError
      Rails.env.production? || Rails.env.staging? ? Raven.capture_exception(e) : raise(e)
    end
  end

  Classification.prepend(ClassificationDecorator)
end
