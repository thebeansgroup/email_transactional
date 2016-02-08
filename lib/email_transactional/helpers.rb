module EmailTransactional
  module Helpers
    TMPL_OPEN_TAG  = '[[['.freeze
    TMPL_CLOSE_TAG = ']]]'.freeze

    def image_url(source)
      "http://cdn.ymaservices.com/email_transactional/#{source}"
    end

    def tagify(name)
      TMPL_OPEN_TAG + name + TMPL_CLOSE_TAG.html_safe
    end

    def markdown(text)
      Kramdown::Document.new(text).to_html.html_safe
    end

    def t(key, options = {})
      I18n.t(key, options)
    end
  end
end
