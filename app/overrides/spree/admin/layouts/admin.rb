Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
  name: 'Add correct title and favicon',
  insert_before: 'head',
  text: <<-HTML
          <% content_for :head do %>
            <%= favicon_link_tag 'favicon-dashboard.png' %>
          <% end %>
          <% content_for :title do %>
            <%= "Dashboard – " %>
            <%= Spree.t(controller.controller_name, default: controller.controller_name.titleize) %>
          <% end %>
  HTML
)
