module Spree
  module FrontendHelper # rubocop:disable Metrics/ModuleLength
    # rubocop:disable Metrics/AbcSize, Metrics/LineLength, Rails/OutputSafety
    def spree_breadcrumbs(taxon, separator = '&nbsp;')
      return '' if current_page?('/') || taxon.nil?
      separator = raw(separator)
      crumbs = [content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:home), itemprop: 'name'), spree.root_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')]
      if taxon
        # crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:products), itemprop: 'name'), spree.products_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
        crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, content_tag(:span, link_to(content_tag(:span, ancestor.name, itemprop: 'name'), seo_url(ancestor), itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement') } unless taxon.ancestors.empty?
        current_crumb = content_tag(:span, taxon.name, itemprop: 'name')
        # current_crumb = link_to(current_crumb, seo_url(taxon), itemprop: 'url') unless current_page?(seo_url(taxon))
        crumbs << content_tag(:li, content_tag(:span, current_crumb, itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
      else
        crumbs << content_tag(:li, content_tag(:span, Spree.t(:products), itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
      end
      crumb_list = content_tag(:ol, raw(crumbs.flatten.map(&:mb_chars).join), class: 'breadcrumb', itemscope: 'itemscope', itemtype: 'https://schema.org/BreadcrumbList')
      content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'col-md-12')
    end
    # rubocop:enable Metrics/AbcSize, Metrics/LineLength, Rails/OutputSafety

    def compared_user_addresses(address)
      spree_current_user.addresses.map { |a| [a, address.same_as?(a)] }
    end

    def link_to_cart(text = nil) # rubocop:disable Metrics/AbcSize
      text = text ? h(text) : Spree.t('cart')
      css_class = nil

      if simple_current_order.nil? || (orders_count = simple_current_order.item_count).zero?
        text = image_tag('icons/cart.svg')
        css_class = 'empty'
      else
        text = "#{image_tag('icons/cart.svg')}<span class='badge'>#{orders_count}</span>"
        css_class = 'full'
      end

      link_to text.html_safe, spree.cart_path, class: "cart-info #{css_class}" # rubocop:disable Rails/OutputSafety
    end

    def inline_svg(path)
      source = Rails.application.assets_manifest.find_sources(path + '.svg').first
      raw(source) # rubocop:disable Rails/OutputSafety
    end

    def vendor_reputation_text(vendor)
      reputation = cached_reputation(vendor)

      if reputation.present? && reputation.score.present?
        number_to_percentage(reputation.score * 100, precision: 1)
      else
        Spree.t('not_enough_ratings')
      end
    end

    def rating_html(shipment)
      rating = cached_rating(shipment)

      rating.present? ? t("orders.rating#{rating.display_value}") : t('orders.rating-none')
    end

    def cached_reputation(vendor)
      uid = vendor&.reputation_uid
      return unless uid

      Rails.cache.fetch(GlobalReputation::Api::Reputation.cache_key(uid), expires_in: 1.hour) do
        GlobalReputation::Api::Reputation.find(uid).first
      end
    end

    def cached_rating(shipment)
      return unless shipment.rating_uid

      Rails.cache.fetch(shipment.rating_uid) do
        GlobalReputation::Api::Rating.find(shipment.rating_uid).first
      end
    end

    def can_rate?(shipment)
      cached_rating(shipment)&.modification.blank?
    end

    def flash_messages(opts = {}) # rubocop:disable Metrics/AbcSize
      ignore_types = ['order_completed'].concat(Array(opts[:ignore_types]).map(&:to_s) || [])

      close_button = button_tag('class' => 'close', 'data-dismiss' => 'alert', 'aria-label' => Spree.t(:close)) do
        content_tag('span', '&times;'.html_safe, 'aria-hidden' => true) # rubocop:disable Rails/OutputSafety
      end

      flash.each do |msg_type, text|
        unless ignore_types.include?(msg_type)
          alert_class = "alert alert-dismissible alert-top alert-#{msg_type}"
          concat(content_tag(:div, content_tag(:div, close_button + text, class: 'container'), class: alert_class))
        end
      end
      nil
    end

    def product_image_or_default(product, style)
      if (image = product.images.first).present?
        image.attachment.url(style)
      else
        image_path("noimage/#{style}.png")
      end
    end

    def product_card_size(size = nil)
      size == :medium ? 'col-lg-3 col-md-3 col-sm-4 col-xs-6' : 'col-lg-2 col-md-3 col-sm-4 col-xs-6'
    end

    def show_more(text, length: 200, link: 'Read more', omission: '...')
      return text if text.length < length

      content = [content_tag(:span, text[0...length])]
      content << content_tag(:span, omission)
      content << content_tag(:span, text[length..text.length], class: 'hide')
      content << content_tag(:a, link, class: 'show-more')

      safe_join(content)
    end

    def mobile?
      browser.device.mobile?
    end

    def show_taxon_previews?
      @show_taxon_previews ||= mobile? && @taxon.root? && %w[keywords filter sort].all? { |par| params[par].blank? }
    end

    def card_variation(product)
      product.variation_finder&.card_variation_name(product)
    end

    def titleized_variation_name(product_variation)
      t("variations.titleized-format.#{product_variation}", default: product_variation.titleize)
    end
  end
end
