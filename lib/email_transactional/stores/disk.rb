module EmailTransactional
  module Stores
    class Disk
      include Singleton

      BUILD_PATH = '../../../../build/'
      EMAILS_PATH = BUILD_PATH + 'emails/'
      EXTENSION = '.html'

      def store_email(email)
        create_locale_dir(email)
        write(email)
      end

      private

      def create_locale_dir(email)
        path = locale_path(email)
        Dir.mkdir(path) unless File.directory?(path)
      end

      def locale_path(email)
        File.expand_path(EMAILS_PATH + email.locale, __FILE__)
      end

      def write(email)
        File.write(path(email), email.html)
      end

      def path(email)
        locale_path(email) + '/' + email.name + EXTENSION
      end
    end
  end
end
