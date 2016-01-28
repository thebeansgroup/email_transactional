module Email
  module Middleman
    def self.build
      `bundle exec middleman build`
    end
  end
end
