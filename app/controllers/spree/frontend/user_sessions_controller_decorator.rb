Spree::UserSessionsController.class_eval do
  def create
    super do |resource|
      session[:mixpanel_actions] = [
        "mixpanel.identify('#{resource.id}')",
        %(mixpanel.people.set({
          "$first_name": "#{resource.first_name}",
          "$last_name": "#{resource.last_name}",
          "$email": "#{resource.try(:email)}",
          "$created": "#{resource.created_at}"
        })),
        %(mixpanel.track('signin', {
          "user_id": "#{resource.id}",
          "email": "#{resource.try(:email)}"
        }))
      ]
    end
  end
end
