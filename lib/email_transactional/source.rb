module EmailTransactional
  class Source
    SOURCE_PATH = '../../../source/'
    LOCALIZABLE_DIR = 'localizable/'
    EMAILS_PATH = SOURCE_PATH + LOCALIZABLE_DIR
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

    def self.path
      Pathname.new(File.expand_path(SOURCE_PATH, __FILE__))
    end

    private

    def self.single_email(name, locales, block)
      path = File.expand_path(EMAILS_PATH + name + EMAILS_EXTENSION, __FILE__)
      locales.each do |locale|
        block.call(EmailTransactional::Email.new(name, template(name), locale))
      end
    end

    def self.all_emails(locales, block)
      path = File.expand_path(EMAILS_PATH, __FILE__)
      names = Dir.glob(path + '/*' + EMAILS_EXTENSION).map do |file|
        locales.each do |locale|
          name = File.basename(file, EMAILS_EXTENSION)
          block.call(
            EmailTransactional::Email.new(name, template(name), locale)
          )
        end
      end
    end

    def self.get_locales(locale)
      if locale
        [locale]
      else
        EmailTransactional::Locales.all
      end
    end

    def self.template(name)
      LOCALIZABLE_DIR + name + EMAILS_EXTENSION
    end
  end
end
