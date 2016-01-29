module EmailTransactional
  class Source
    SOURCE_PATH = '../../../source/'
    EMAILS_PATH = SOURCE_PATH + 'localizable/'
    LAYOUTS_PATH = SOURCE_PATH + 'layouts/'
    EMAILS_EXTENSION = '.html.erb'
    LAYOUTS_EXTENSION = '.erb'
    DEFAULT_LAYOUT = 'layout'

    def self.emails(name = nil,  locale = nil, &block)
      locales = get_locales(locale)
      if name
        single_email(name, locales, block)
      else
        all_emails(locales, block)
      end
    end

    def self.layout
      relative_path = LAYOUTS_PATH + DEFAULT_LAYOUT + LAYOUTS_EXTENSION
      path = File.expand_path(relative_path, __FILE__)
      read_file(path)
    end

    private

    def self.single_email(name, locales, block)
      path = File.expand_path(EMAILS_PATH + name + EMAILS_EXTENSION, __FILE__)
      html = read_file(path)
      locales.each do |locale|
        block.call(EmailTransactional::Email.new(name, locale, html))
      end
    end

    def self.all_emails(locales, block)
      path = File.expand_path(EMAILS_PATH, __FILE__)
      names = Dir.glob(path + '/*' + EMAILS_EXTENSION).map do |file|
        locales.each do |locale|
          block.call(EmailTransactional::Email.new(
            File.basename(file, EMAILS_EXTENSION),
            locale,
            read_file(file)
          ))
        end
      end
    end

    def self.read_file(path)
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
