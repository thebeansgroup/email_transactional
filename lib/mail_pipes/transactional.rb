module MailPipes
  module Transactional
    def self.get(name, locale)
      store = MailPipes::Stores::Memcached.instance
      html = store.get_email(name, locale)
      MailPipes::Transactional::Template.new(html)
    end

    def self.rebuild(template = nil, locale = nil)
      pipeline = MailPipes::Pipeline.in(Config.environment)
      pipeline.run(template, locale)
    end
  end
end

require_relative './transactional/template'
