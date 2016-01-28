module Email
  class Transactional
    def self.get(name, locale)
      html = Email::Store.instance.get_email(name, locale)
      Email::Template.new(html)
    end

    def self.rebuild
      Email::Middleman.build
      Email::Reader.default.read_all do |name, locale, html|
        Email::Store.instance.store_email(name, locale, html)
      end
    end
  end
end
