module EmailTransactional
  class Pipeline

    def self.in(_environment)
      # TODO: check environment
      store = EmailTransactional::Stores::Memcached.instance
      builder = EmailTransactional::PipelineBuilder.new(
        EmailTransactional::Stages::ActionView.new,
        EmailTransactional::Stages::InlineCSS.new,
        EmailTransactional::Stages::Store.new(store)
      ).before do
        EmailTransactional::Stylesheets.compile
      end.after do
        EmailTransactional::DirectoryIndex.build
      end.build
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
  end
end
