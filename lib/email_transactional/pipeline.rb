module EmailTransactional
  class Pipeline
    def self.in(environment)
      if [:development, :test].include?(environment.to_sym)
        development_pipeline
      elsif environment.to_sym == :production
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
      EmailTransactional::Source.emails(name, locale) do |email|
        @stages.each do |stage|
          email = stage.run(email)
        end
      end
      @after.call
    end

    class << self

      private

      def development_pipeline
        store = EmailTransactional::Stores::Disk.instance
        EmailTransactional::PipelineBuilder.new(
          EmailTransactional::Stages::ActionView.new,
          EmailTransactional::Stages::InlineCSS.new,
          EmailTransactional::Stages::Store.new(store)
        ).before { EmailTransactional::Stylesheets.compile }
         .after { EmailTransactional::DirectoryIndex.build }
         .build
      end

      def production_pipeline
        store = EmailTransactional::Stores::Memcached.instance
        EmailTransactional::PipelineBuilder.new(
          EmailTransactional::Stages::ActionView.new,
          EmailTransactional::Stages::InlineCSS.new,
          EmailTransactional::Stages::Store.new(store)
        ).before { EmailTransactional::Stylesheets.compile }
         .build
      end
    end
  end
end
