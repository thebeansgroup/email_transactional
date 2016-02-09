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
        @dalli.set(email.key_txt, email.text)
      end

      def get_email(name, locale)
        @dalli.get(EmailTransactional::Email.new(name, nil, locale, nil).key)
      end

      def get_email_text(name, locale)
        key = EmailTransactional::Email.new(name, nil, locale, nil).key_txt
        @dalli.get(key)
      end
    end
  end
end
