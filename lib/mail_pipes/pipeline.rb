module MailPipes
  class Pipeline
    def self.in(environment)
      if [:development, :test].include?(environment.to_sym)
        development_pipeline
      elsif [:production, :staging].include?(environment.to_sym)
        production_pipeline
      else
        raise 'Unknown environment'
      end
    end

    def initialize(before,
                   stages,
                   after)
      @before = before
      @stages = stages
      @after = after
    end

    def run(name = nil, locale = nil)
      @before.call
      MailPipes::Source.emails(name, locale) do |email|
        @stages.each do |stage|
          email = stage.run(email)
        end
      end
      @after.call
    end

    class << self
      private

      def development_pipeline
        store = MailPipes::Stores::Disk.instance
        MailPipes::PipelineBuilder
          .new(*stages(store))
          .before { MailPipes::Stylesheets.compile }
          .after { MailPipes::DirectoryIndex.build }
          .build
      end

      def production_pipeline
        store = MailPipes::Stores::Memcached.instance
        MailPipes::PipelineBuilder
          .new(*stages(store))
          .before { MailPipes::Stylesheets.compile }
          .build
      end

      def stages(store)
        [MailPipes::Stages::ActionView.new,
         MailPipes::Stages::InlineCSS.new,
         MailPipes::Stages::Store.new(store)]
      end
    end
  end
end
