require 'net/ftp'

module PublicMarket
  class FTP
    attr_accessor :net_ftp

    def initialize(ftp_key, opts = {})
      creds = Rails.application.credentials[ftp_key]
      @net_ftp = Net::FTP.new(creds[:url],
                              port: creds[:port],
                              username: creds[:user],
                              password: creds[:password],
                              debug_mode: opts[:debug])
    end

    delegate :nlst, to: :net_ftp
  end
end
