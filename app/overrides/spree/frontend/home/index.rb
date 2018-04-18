Deface::Override.new(
  virtual_path: 'spree/home/index',
  name: 'Mixpanel view homepage event',
  insert_top: '[data-hook=homepage_products]',
  disabled: !%w[staging production].include?(Rails.env),
  text: <<~HTML
    <script type="text/javascript">
      mixpanel.track(
        "homepage view"
      );
    </script>
  HTML
)
