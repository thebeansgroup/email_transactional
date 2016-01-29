module EmailTransactional
  class Locales
    LOCALE_PATH = '../../../locales'

    def self.all
      path = File.expand_path(LOCALE_PATH, __FILE__)
      Dir.glob("#{path}/*.yml").map do |file|
        File.basename(file, '.yml')
      end
    end
  end
end
