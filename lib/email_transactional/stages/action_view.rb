module EmailTransactional
  module Stages
    class ActionView
      include ::ActionView::Helpers::TagHelper

      def initialize
        @action_view = ::ActionView::Base.new(EmailTransactional::Source.path)
        @action_view.class_eval do
          include EmailTransactional::Globals.helper
          include EmailTransactional::Config.helper
          include EmailTransactional::Helpers
        end
      end

      def run(email)
        I18n.locale = email.locale
        html = @action_view.render(template: email.template)
        EmailTransactional::Email.new(
          email.name,
          email.template,
          email.locale,
          html
        )
      end
    end
  end
end
