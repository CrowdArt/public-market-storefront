Spree::Search::Searchkick.class_eval do
  attr_accessor :enable_aggs

  def aggregations
    return unless enable_aggs

    fs = {
      price_range: price_ranges_agg
    }

    Spree::Taxonomy.filterable.each do |taxonomy|
      field = taxonomy.filter_name.to_sym
      fs[field] = { terms: { field: field }}
    end

    Spree::Property.filterable.each do |property|
      field = property.filter_name.to_sym
      fs[field] = { terms: { field: field }}
    end

    fs
  end

  private

  def prepare(params)
    super
    @properties[:conversions] = params[:conversions]
    self.enable_aggs = params[:enable_aggs]
  end

  def where_query
    where_query = {
      active: true,
      currency: current_currency,
      price: { not: nil }
    }
    where_query[:taxon_ids] = taxon.id if taxon
    add_search_filters(where_query)
  end

  ALLOWED_WHERE_PARAMS = %i[format].freeze
  def add_search_filters(query)
    return query unless search

    search.select { |param, _val| ALLOWED_WHERE_PARAMS.include?(param) }.each do |name, scope_attribute|
      query.merge!(Hash[name, scope_attribute])
    end

    add_price_filter(query)

    query
  end

  def add_price_filter(query)
    return if (price_ranges = search['price']).blank?

    price_ranges.each do |price_range|
      matched_filter = fixed_price_ranges.find { |r| r[:key].to_s == price_range }
      query[:price] = { gt: matched_filter[:from], lt: matched_filter[:to] } if matched_filter
    end
  end

  def price_ranges_agg
    {
      ranges: fixed_price_ranges,
      field: :price
    }
  end

  def fixed_price_ranges
    [
      { key: :to_5, to: 5 },
      { key: :from_5_to_10, from: 5, to: 10 },
      { key: :from_10_to_20, from: 10, to: 20 },
      { key: :from_20, from: 20 }
    ]
  end
end
