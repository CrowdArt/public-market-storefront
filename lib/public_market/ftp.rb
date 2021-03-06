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

    delegate :nlst, :status, :get, :put, :delete, :rmdir, :close, to: :net_ftp

    def mkdir(dir)
      net_ftp.mkdir(dir) unless nlst.include?(dir)
    end
  end
end
