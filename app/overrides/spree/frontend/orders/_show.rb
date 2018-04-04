Deface::Override.new(
  virtual_path: 'spree/orders/show',
  name: 'Add rating form',
  insert_before: '#order',
  partial: 'spree/ratings/form'
)

Deface::Override.new(
  virtual_path: 'spree/orders/show',
  name: 'Add freshdesk link',
  replace_contents: 'p[data-hook="links"]',
  text: <<-HTML
          <%= link_to Spree.t(:back_to_store), spree.root_path, class: "button" %>
          <% unless order_just_completed?(@order) %>
            &nbsp;|&nbsp;
            <% if try_spree_current_user && respond_to?(:account_path) %>
              <%= link_to Spree.t(:my_account), account_path, class: "button" %>
            <% end %>
          <% end %>
          &nbsp;|&nbsp;<%= link_to Spree.t('order_support'), main_app.freshdesk_url %>
        HTML
)
