class FreshdeskController < ApplicationController
  before_action :authenticate_spree_user!

  def login
    utctime = time_in_utc
    redirect_url = [
      Rails.application.credentials.freshdesk_url,
      'login/sso?',
      { name: spree_current_user.full_name_or_email,
        email: spree_current_user.email,
        timestamp: utctime,
        hash: gen_hash_from_params_hash(utctime),
        redirect_to: '/support/tickets/new'
      }.to_query
    ].join
    redirect_to(redirect_url)
  end

  private

  def gen_hash_from_params_hash(utctime)
    digest = OpenSSL::Digest.new('MD5')
    OpenSSL::HMAC.hexdigest(
      digest,
      Rails.application.credentials.freshdesk_token,
      [spree_current_user.full_name_or_email,
       Rails.application.credentials.freshdesk_token,
       spree_current_user.email,
       utctime].join
    )
  end

  def time_in_utc
    Time.now.getutc.to_i.to_s
  end
end
