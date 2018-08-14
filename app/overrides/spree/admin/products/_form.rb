Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'Add number in product form',
  insert_bottom: 'div[data-hook="admin_product_form_additional_fields"]',
  text: <<-HTML
          <%= f.field_container :number, class: ['form-group'] do %>
            <%= f.label :number, Spree.t(:product_number) %>
            <%= f.text_field :number, class: 'form-control' %>
          <% end %>
  HTML
)

Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'Add product collection in product form',
  insert_bottom: 'div[data-hook="admin_product_form_additional_fields"]',
  text: <<-HTML
          <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
            <%= f.field_container :product_collection_ids, class: ['form-group'] do %>
              <%= f.label :product_collection_ids, Spree.t(plural_resource_name(Spree::ProductCollection)) %>
              <%= f.collection_select :product_collection_ids, Spree::ProductCollection.all, :id, :name, { }, { class: 'select2', multiple: true } %>
            <% end %>
          <% end %>
  HTML
)
