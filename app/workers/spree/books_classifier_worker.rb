module Spree
  class BooksClassifierWorker
    include Sidekiq::Worker
    sidekiq_options queue: :recalculation

    # rubocop:disable Metrics/AbcSize
    def perform(product_id)
      product = Spree::Product.find(product_id)
      taxonomy = Spree::Taxonomy.find_by(name: 'Books')

      isbn = product.property('isbn')
      subject = product.property('book_subject')

      subject = fetch_subject(isbn) if subject.blank?

      return if subject.blank?

      product.set_property('book_subject', subject, 'Subject')

      taxon_candidates = subject.split('; ')
                                .select { |s| s.include?('/') }
                                .map { |s| s.split(' / ') }

      Spree::Inventory::Providers::Books::Classifier.call(product, taxonomy, taxon_candidates)
    end

    private

    def fetch_subject(isbn)
      creds = { username: Settings.bowker_user, password: Settings.bowker_password }
      url = "https://bms.bowker.com/rest/books/isbn/#{isbn}?format=xml"
      result = HTTParty.get(url, basic_auth: creds).parsed_response
      item = result.dig('result', 'item')

      return if item.blank?

      detail_url = item.is_a?(Array) ? item[0]['details'] : item['details']

      return if detail_url.blank?

      details = HTTParty.get(detail_url, basic_auth: creds).parsed_response
      details&.dig('result', 'item', 'subject')
    end
    # rubocop:enable Metrics/AbcSize
  end
end
