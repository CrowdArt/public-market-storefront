Deface::Override.new(
  virtual_path: 'spree/admin/variants/_form',
  name: 'Add rewards in variant form',
  insert_bottom: 'div[data-hook="admin_variant_form_additional_fields"]',
  text: <<-HTML
          <%= f.field_container :rewards, class: ['form-group'] do %>
            <%= f.label :rewards %>
            <%= f.select :rewards, rewards_options(f.object.rewards), { include_blank: Spree.t('vendor_rewards', vendor_name: f.object.vendor&.presentation_or_name, rewards: f.object.vendor&.final_rewards) }, class: 'form-control' %>
          <% end %>
  HTML
)
