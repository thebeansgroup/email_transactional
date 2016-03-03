module MailPipes
  module Stylesheets
    ROOT_PATH = '../../../'.freeze

    def self.compile
      path = File.expand_path(ROOT_PATH, __FILE__)
      Dir.chdir(path) do
        `bundle exec compass compile`
      end
    end
  end
end
