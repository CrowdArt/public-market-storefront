require 'sidekiq-scheduler'

class CapturePayments
  include Sidekiq::Worker

  def perform
    Spree::Payments::CapturePaymentsAction.new.call
  end
end
