Deface::Override.new(
  virtual_path:  'spree/admin/shared/sub_menu/_product',
  name:          'product_collections_main_menu_tabs',
  insert_bottom: '#sidebar-product',
  text: <<-HTML
          <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
            <%= tab plural_resource_name(Spree::ProductCollection), url: admin_product_collections_path, match_path: '/product_collections' %>
          <% end %>
  HTML
)
