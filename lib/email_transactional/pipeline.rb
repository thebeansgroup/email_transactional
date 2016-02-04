module EmailTransactional
  class Pipeline

    def self.in(_environment)
      # return basic pipeline for now
      store = EmailTransactional::Stores::Disk.instance
      new([EmailTransactional::Stages::ActionView.new,
           EmailTransactional::Stages::Store.new(store)])

    end

    def initialize(stages)
      @stages = stages
    end

    def run(name = nil, locale = nil)
      EmailTransactional::Source.emails(name, locale) do |email|
        @stages.each do |stage|
          email = stage.run(email)
        end
      end
    end
  end
end
