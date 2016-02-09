module EmailTransactional
  class Locales
    LOCALE_PATH = '../../../locales'.freeze

    def self.all
      Dir.glob("#{path}/*.yml").map do |file|
        File.basename(file, '.yml')
      end
    end

    def self.path
      File.expand_path(LOCALE_PATH, __FILE__)
    end
  end
end
