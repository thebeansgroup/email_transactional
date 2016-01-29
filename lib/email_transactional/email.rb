module EmailTransactional
  class Email
    attr_reader :name, :locale, :html

    def initialize(name, locale, html)
      @name = name
      @locale = locale
      @html = html
    end
  end
end
