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
