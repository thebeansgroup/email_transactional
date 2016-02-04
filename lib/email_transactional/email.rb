module EmailTransactional
  class Email
    attr_reader :name, :template, :locale, :html, :text

    def initialize(name, template, locale, html = nil, text = nil)
      @name = name
      @template = template
      @locale = locale
      @html = html
      @text = text
    end

    def key
      "#{@name}-#{@locale}"
    end
  end
end
