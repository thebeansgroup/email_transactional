module EmailTransactional
  class MemcachedStore
    MEMCACHED_NAMESPACE = 'email_store'.freeze

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

    def store_email(email)
      @dalli.set(email.key, email.html)
    end

    def store_all(emails)
      emails.each do |email|
        store_email(email)
      end
    end

    def get_email(name, locale)
      @dalli.get(EmailTransactional::Email.new(name, nil, locale).key)
    end
  end
end
