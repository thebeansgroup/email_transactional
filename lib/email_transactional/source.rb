module EmailTransactional
  class Source
    SOURCE_PATH = '../../../source/'.freeze
    LOCALIZABLE_DIR = 'localizable/'.freeze
    EMAILS_PATH = SOURCE_PATH + LOCALIZABLE_DIR
    LAYOUTS_PATH = SOURCE_PATH + 'layouts/'.freeze
    EMAILS_EXTENSION = '.html.erb'.freeze
    LAYOUTS_EXTENSION = '.erb'.freeze
    DEFAULT_LAYOUT = 'layout'.freeze

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
            EmailTransactional::Email.new(
              name,
              template(name),
              locale,
              default_layout
            )
          )
        end
      end

      def all_emails(locales, block)
        Dir.glob(path + '/*' + EMAILS_EXTENSION).map do |file|
          locales.each do |locale|
            name = File.basename(file, EMAILS_EXTENSION)
            block.call(
              EmailTransactional::Email.new(
                name,
                template(name),
                locale,
                default_layout
              )
            )
          end
        end
      end

      def get_locales(locale)
        if locale
          [locale]
        else
          EmailTransactional::Locales.all
        end
      end

      def template(name)
        LOCALIZABLE_DIR + name + EMAILS_EXTENSION
      end

      def default_layout
        relative_path = LAYOUTS_PATH + DEFAULT_LAYOUT + LAYOUTS_EXTENSION
        File.expand_path(relative_path, __FILE__)
      end
    end
  end
end
