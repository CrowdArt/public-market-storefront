Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'Mixpanel view product event',
  insert_top: '[data-hook=product_show]',
  disabled: !%w[staging production].include?(Rails.env),
  text: <<~HTML
    <script type="text/javascript">
      mixpanel.track("product view", {
        "id": "<%= @product.id %>",
        "name": "<%= @product.name %>"
      });
    </script>
  HTML
)
