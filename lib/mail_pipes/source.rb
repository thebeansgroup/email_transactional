module MailPipes
  class Source
    SOURCE_PATH = '../../../source/'.freeze
    LOCALIZABLE_DIR = 'localizable/'.freeze
    EMAILS_PATH = SOURCE_PATH + LOCALIZABLE_DIR
    EMAILS_EXTENSION = '.html.erb'.freeze

    class << self
      def emails(name = nil, locale = nil, &block)
        locales = get_locales(locale)
        if name
          single_email(name, locales, block)
        else
          all_emails(locales, block)
        end
      end

      def path
        Pathname.new(File.expand_path(SOURCE_PATH, __FILE__))
      end

      private

      def single_email(name, locales, block)
        locales.each do |locale|
          block.call(
            MailPipes::Email.new(
              name,
              template(name),
              locale,
              Layouts.instance.get(name)
            )
          )
        end
      end

      def all_emails(locales, block)
        emails_path = File.expand_path(EMAILS_PATH, __FILE__)
        size = Dir.glob(emails_path + '/*' + EMAILS_EXTENSION).size
        index = 0
        Dir.glob(emails_path + '/*' + EMAILS_EXTENSION).map do |file|
          locales.each do |locale|
            name = File.basename(file, EMAILS_EXTENSION)
            index += 1
            puts "Email #{index}/#{size*locales.size}"
            block.call(
              MailPipes::Email.new(
                name,
                template(name),
                locale,
                Layouts.instance.get(name)
              )
            )
          end
        end
      end

      def get_locales(locale)
        if locale
          [locale]
        else
          MailPipes::Locales.all
        end
      end

      def template(name)
        LOCALIZABLE_DIR + name + EMAILS_EXTENSION
      end
    end
  end
end
