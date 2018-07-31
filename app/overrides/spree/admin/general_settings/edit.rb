Deface::Override.new(
  virtual_path: 'spree/admin/general_settings/edit',
  name: 'Add Global Rewards to General Settings',
  insert_before: 'div[data-hook="buttons"]',
  text: <<-HTML
          <div class="row">
            <div class="col-xs-12 col-md-6">
              <div class="panel panel-default">
                <div class="panel-heading">
                  <h1 class="panel-title"><%= Spree.t(:global_rewards)%></h1>
                </div>

              <div class="panel-body">
                <div class="form-group">
                  <%= label_tag :rewards, Spree.t(:select_rewards) %>
                  <%= select_tag :rewards, rewards_options(Spree::Config.rewards), class: 'form-control' %>
                </div>
            </div>
          </div>
  HTML
)
