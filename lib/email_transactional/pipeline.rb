module EmailTransactional
  class Pipeline

    def self.in(_environment)
      # TODO: check environment
      store = EmailTransactional::Stores::Disk.instance
      new([EmailTransactional::Stages::ActionView.new,
           EmailTransactional::Stages::InlineCSS.new,
           EmailTransactional::Stages::Store.new(store)])

    end

    def initialize(stages)
      @stages = stages
    end

    def run(name = nil, locale = nil)
     # EmailTransactional::Sass.compile
      EmailTransactional::Source.emails(name, locale) do |email|
        @stages.each do |stage|
          email = stage.run(email)
        end
      end
    end
  end
end
