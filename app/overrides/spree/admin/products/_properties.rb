Deface::Override.new(
  virtual_path: 'spree/products/_properties',
  name: 'Add product weight/dimensions under properties',
  insert_before: 'erb[silent]:contains("reset_cycle(\'properties\')")',
  text: <<-HTML
          <tr class="<%= current_cycle %>">
            <td><strong>Dimensions</strong></td>
            <td><%= [@product.width, @product.depth, @product.height].join(' x ') %> inches</td>
          </tr>
          <tr class="<%= current_cycle %>">
            <td><strong>Weight</strong></td>
            <td><%= @product.weight %> ounces</td>
          </tr>
  HTML
)
