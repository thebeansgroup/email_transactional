module EmailTransactional
  class Email
    attr_reader :name, :template, :locale, :layout, :html, :text

    def initialize(name, template, locale, layout, html = nil, text = nil)
      @name = name
      @template = template
      @locale = locale
      @layout = layout
      @html = html
      @text = text
    end

    def key
      "#{@name}-#{@locale}"
    end

    def key_txt
      "#{@name}-#{@locale}-txt"
    end
  end
end
