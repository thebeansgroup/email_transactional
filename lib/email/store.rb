# move this require in gemspec
require 'dalli'

module Email
  class Store
    MEMCACHED_NAMESPACE = 'email_store'.freeze

    def self.server=(server)
      @server = server
    end

    def self.instance
      @instance ||= new(@server)
    end

    def initialize(server)
      @dalli = Dalli::Client.new(
        server,
        namespace: MEMCACHED_NAMESPACE,
        compress: true
      )
    end

    def store_email(name, locale, html)
      @dalli.set(build_key(name, locale), html)
    end

    def get_email(name, locale)
      @dalli.get(build_key(name, locale))
    end

    private

    def build_key(name, locale)
      Email::Key.new(name, locale).build
    end
  end
end
