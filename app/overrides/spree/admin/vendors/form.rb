Deface::Override.new(
  virtual_path: 'spree/admin/vendors/_form',
  name: 'Add Global Rewards to Vendor form',
  insert_bottom: 'div.form-group',
  text: <<-HTML
          <%= f.field_container :rewards do %>
            <%= f.label :rewards %>
            <%= f.select :rewards, rewards_options(f.object.rewards), { include_blank: Spree.t('default_rewards', rewards: Spree::Config[:rewards]) }, class: 'form-control' %>
          <% end %>
  HTML
)
