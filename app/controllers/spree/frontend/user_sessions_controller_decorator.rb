Spree::UserSessionsController.class_eval do
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    super do |resource|
      flash[:mixpanel_actions] = [
        "mixpanel.identify('#{resource.id}')",
        %Q(mixpanel.people.set({
          "$first_name": "#{resource.first_name}",
          "$last_name": "#{resource.last_name}",
          "$email": "#{resource.try(:email)}",
          "$created": "#{resource.created_at}"
        })),
        %Q(mixpanel.track('signin', {
          "user_id": "#{resource.id}",
          "email": "#{resource.try(:email)}"
        }))
      ].to_json
    end
  end
end
