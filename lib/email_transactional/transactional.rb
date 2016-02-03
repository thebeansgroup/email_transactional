module EmailTransactional
  class Transactional
    def self.get(name, locale)
      html = EmailTransactional::Store.instance.get_email(name, locale)
      EmailTransactional::Template.new(html)
    end

    def self.rebuild(template = nil, locale = nil)
      pipeline = EmailTransactional::Pipeline.in(Config.environment)
      pipeline.run(template, locale)
    end
  end
end
