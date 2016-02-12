module MailPipes
  module Stages
    class ActionView
      include ::ActionView::Helpers::TagHelper

      def initialize
        @action_view = ::ActionView::Base.new(MailPipes::Source.path)
        @action_view.class_eval do
          include MailPipes::Globals.helper
          include MailPipes::Config.helper
          include MailPipes::Helpers
        end
      end

      def run(email)
        initial_locale = I18n.locale
        I18n.locale = email.locale
        html = @action_view.render(layout: email.layout,
                                   template: email.template)
        I18n.locale = initial_locale
        MailPipes::Email.new(
          email.name,
          email.template,
          email.locale,
          email.layout,
          html
        )
      end
    end
  end
end
