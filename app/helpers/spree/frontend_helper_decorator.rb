module Spree
  module FrontendHelper
    # rubocop:disable Metrics/AbcSize, Metrics/LineLength, Rails/OutputSafety
    def spree_breadcrumbs(taxon, separator = '&nbsp;')
      return '' if current_page?('/') || taxon.nil?
      separator = raw(separator)
      crumbs = [content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:home), itemprop: 'name'), spree.root_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')]
      if taxon
        # crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:products), itemprop: 'name'), spree.products_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
        crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, content_tag(:span, link_to(content_tag(:span, ancestor.name, itemprop: 'name'), seo_url(ancestor), itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement') } unless taxon.ancestors.empty?
        crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, taxon.name, itemprop: 'name'), seo_url(taxon), itemprop: 'url'), itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
      else
        crumbs << content_tag(:li, content_tag(:span, Spree.t(:products), itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
      end
      crumb_list = content_tag(:ol, raw(crumbs.flatten.map(&:mb_chars).join), class: 'breadcrumb', itemscope: 'itemscope', itemtype: 'https://schema.org/BreadcrumbList')
      content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'col-md-12')
    end

    def taxons_tree(root_taxon, current_taxon, max_level = 1)
      return '' if max_level < 1 || root_taxon.leaf?
      content_tag :div, class: 'list-group' do
        taxons = root_taxon.children.reorder(:name).map do |taxon|
          next if taxon.hidden?
          css_class = current_taxon&.self_and_ancestors&.include?(taxon) ? 'list-group-item active' : 'list-group-item'
          link_to(taxon.name, seo_url(taxon), class: css_class) + taxons_tree(taxon, current_taxon, max_level - 1)
        end
        safe_join(taxons, "\n")
      end
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
      raw(Rails.application.assets.find_asset(path + '.svg').to_s) # rubocop:disable Rails/OutputSafety
    end

    def vendor_reputation_text(vendor)
      reputation = cached_reputation(vendor)

      if reputation.present? && reputation.score.present?
        number_to_percentage(reputation.score * 100, precision: 1)
      else
        Spree.t('not_enough_ratings')
      end
    end

    def cached_reputation(vendor)
      uid = vendor&.reputation_uid
      return unless uid

      Rails.cache.fetch(GlobalReputation::Api::Reputation.cache_key(uid), expires_in: 1.hour) do
        GlobalReputation::Api::Reputation.find(uid).first
      end
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
  end
end
