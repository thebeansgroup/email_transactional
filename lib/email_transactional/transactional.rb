module EmailTransactional
  class Transactional
    def self.get(name, locale)
      html = EmailTransactional::Store.instance.get_email(name, locale)
      EmailTransactional::Template.new(html)
    end

    def self.rebuild
      EmailTransactional::Pipeline.run
      EmailTransactional::Reader.default.read_all do |name, locale, html|
        EmailTransactional::Store.instance.store_email(name, locale, html)
      end
    end
  end
end
