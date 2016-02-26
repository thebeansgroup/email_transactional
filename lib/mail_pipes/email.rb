module MailPipes
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

    def key_subject
      "#{@name}-#{@locale}-subject"
    end

    def subject
      initial_locale = I18n.locale
      I18n.locale = locale
      subject = I18n.t("#{@name}.subject")
      I18n.locale = initial_locale
      subject
    end
  end
end
