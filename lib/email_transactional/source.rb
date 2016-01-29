module EmailTransactional
  class Source
    SOURCE_PATH = '../../../source/localizable/'
    EXTENSION = '.html.erb'

    def self.read(name = nil,  locale = nil, &block)
      locales = get_locales(locale)
      if name
        single_email(name, locales, block)
      else
        all_emails(locales, block)
      end
    end

    private

    def self.single_email(name, locales, block)
      path = File.expand_path(SOURCE_PATH + name + EXTENSION, __FILE__)
      html = read_email(path)
      locales.each do |locale|
        block.call(EmailTransactional::Email.new(name, locale, html))
      end
    end

    def self.all_emails(locales, block)
      path = File.expand_path(SOURCE_PATH, __FILE__)
      names = Dir.glob(path + '/*' + EXTENSION).map do |file|
        locales.each do |locale|
          block.call(EmailTransactional::Email.new(
            File.basename(file, EXTENSION),
            locale,
            read_email(file)
          ))
        end
      end
    end

    def self.read_email(path)
      File.read(path)
    end

    def self.get_locales(locale)
      if locale
        [locale]
      else
        EmailTransactional::Locales.all
      end
    end
  end
end
