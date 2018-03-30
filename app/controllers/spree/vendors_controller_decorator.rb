Spree::VendorsController.class_eval do
  append_before_action :load_reputation, only: [:show]

  private

  def load_reputation
    return unless @vendor.reputation_uid
    @reputation = GlobalReputation::Api::Reputation.find(
      @vendor.reputation_uid
    ).first
  end
end
