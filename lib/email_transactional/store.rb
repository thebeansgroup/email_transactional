class EmailTransactional::Store
  MEMCACHED_NAMESPACE = 'email_store'

  def self.server=(server)
    @server = server
  end

  def self.instance
    @instance ||= new(@server)
  end

  def initialize(server)
    options = {
    }
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
    EmailTransactional::Key.new(name, locale).build
  end
end
