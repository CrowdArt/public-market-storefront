Deface::Override.new(
  virtual_path: 'spree/checkout/_delivery',
  name: 'Remove bottom shipping method',
  remove: 'h4.stock-shipping-method-title, ul.shipping-methods'
)

Deface::Override.new(
  virtual_path: 'spree/checkout/_delivery',
  name: 'Add shipping method to top',
  insert_before: 'h4[data-hook="stock-location"]',
  text: <<-HTML
          <h4><%= Spree.t(:shipping_method) %></h4>
          <ul class="list-group">
            <% ship_form.object.shipping_rates.each do |rate| %>
              <li class="list-group-item shipping-method">
                <label>
                  <%= ship_form.radio_button :selected_shipping_rate_id, rate.id, data: { behavior: 'shipping-method-selector', cost: rate.display_cost } %>
                  <span class="rate-name"><%= rate.name %></span>
                  <span class="badge rate-cost"><%= rate.display_cost %></span>
                </label>
              </li>
            <% end %>
          </ul>
        HTML
)
