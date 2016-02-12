module MailPipes
  module Stylesheets
    def self.compile
      `bundle exec compass compile`
    end
  end
end
