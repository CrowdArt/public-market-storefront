Deface::Override.new(
  virtual_path: 'spree/products/index',
  name: 'Mixpanel product search event',
  insert_top: '[data-hook=search_results]',
  disabled: !%w[staging production].include?(Rails.env),
  text: <<~HTML
    <script type="text/javascript">
      mixpanel.track("product search", {
        "keywords": "<%= params[:keywords] %>",
        "taxonomy": "<%= @taxon.try(:name) %>",
        "results": "<%= @products.length %>"
      });
    </script>
  HTML
)
