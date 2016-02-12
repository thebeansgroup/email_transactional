module MailPipes
  module Stores
    class Memcached
      MEMCACHED_NAMESPACE = 'email_store'.freeze

      def self.instance
        @instance ||= new(MailPipes::Config.memcached_server)
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
        @dalli.get(MailPipes::Email.new(name, nil, locale, nil).key)
      end

      def get_email_text(name, locale)
        key = MailPipes::Email.new(name, nil, locale, nil).key_txt
        @dalli.get(key)
      end
    end
  end
end
