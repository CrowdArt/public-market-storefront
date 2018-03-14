Deface::Override.new(
  virtual_path: 'spree/shared/_order_details',
  name: 'Trucnate order description correctly',
  replace_contents: 'td[data-hook="order_item_description"]',
  text: <<-HTML
          <h4><%= item.name %></h4>
          <%= truncate(strip_tags(item.description.to_s.gsub('&nbsp;', ' ').squish), length: 100) %>
          <%= "(" + item.variant.options_text + ")" unless item.variant.option_values.empty? %>
        HTML
)
