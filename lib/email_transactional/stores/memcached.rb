module EmailTransactional
  module Stores
    class Memcached
      MEMCACHED_NAMESPACE = 'email_store'.freeze

      def self.instance
        @instance ||= new(EmailTransactional::Config.memcached_server)
      end

      def initialize(server)
        @dalli = Dalli::Client.new(
          server,
          namespace: MEMCACHED_NAMESPACE,
          compress: true
        )
      end

      def store_email(email)
        @dalli.set(email.key, email.html)
      end

      def get_email(name, locale)
        @dalli.get(EmailTransactional::Email.new(name, nil, locale, nil).key)
      end
    end
  end
end
