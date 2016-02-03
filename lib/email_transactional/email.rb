module EmailTransactional
  class Email
    attr_reader :name, :template, :locale, :html

    def initialize(name, template, locale, html = nil)
      @name = name
      @template = template
      @locale = locale
      @html = html
    end

    def key
      "#{@name}-#{@locale}"
    end
  end
end
