module EmailTransactional
  module Stages
    class InlineCSS
      TMPL_OPEN_TAG  = '[[['.freeze
      TMPL_CLOSE_TAG = ']]]'.freeze

      EMAIL_PRV_OPEN_TAG = '[EMV DYN]'.freeze
      EMAIL_PRV_CLOSE_TAG = '[EMV /DYN]'.freeze

      def run(email)
        premailer = Premailer.new(
          email.html,
          verbose: true,
          remove_classes: false,
          adapter: 'nokogiri',
          with_html_string: true
        )
        text = parse_text(premailer.to_plain_text)
        html = parse(premailer.to_inline_css)
        EmailTransactional::Email.new(
          email.name,
          email.template,
          email.locale,
          email.layout,
          html,
          text
        )
      end

      def parse(doc)
        html = Nokogiri::HTML(doc)
        head = html.search('head')
        puts head
        html.search('style').each do |el|
          head.children.last.add_previous_sibling(el)
        end
        html.search('img').each do |el|
          alt = el.get_attribute('alt')
          unless alt
            el.set_attribute('alt', '')
          end
        end
        html.search("[align='none']").each do |el|
          el.attributes['align'].remove
        end
        html_str = html.to_html
        html_str = html_str.gsub(TMPL_OPEN_TAG, EMAIL_PRV_OPEN_TAG)
        html_str = html_str.gsub(ERB::Util.url_encode(TMPL_OPEN_TAG),
                                 EMAIL_PRV_OPEN_TAG)
        html_str = html_str.gsub(TMPL_CLOSE_TAG, EMAIL_PRV_CLOSE_TAG)
        html_str = html_str.gsub(ERB::Util.url_encode(TMPL_CLOSE_TAG),
                                 EMAIL_PRV_CLOSE_TAG)
        html_str
      end

      def parse_text(doc)
        text_str = doc
        text_str = text_str.gsub(TMPL_OPEN_TAG, EMAIL_PRV_OPEN_TAG)
        text_str = text_str.gsub(ERB::Util.url_encode(TMPL_OPEN_TAG),
                                 EMAIL_PRV_OPEN_TAG)
        text_str = text_str.gsub(TMPL_CLOSE_TAG, EMAIL_PRV_CLOSE_TAG)
        text_str = text_str.gsub(ERB::Util.url_encode(TMPL_CLOSE_TAG),
                                 EMAIL_PRV_CLOSE_TAG)
        text_str = text_str.gsub('( https://www.facebook.com/studentbeans )',
                                 '')
        text_str = text_str.gsub('( https://twitter.com/studentbeans )', '')
        text_str
      end
    end
  end
end
