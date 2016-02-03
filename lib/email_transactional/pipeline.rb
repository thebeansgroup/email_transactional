module EmailTransactional
  class Pipeline

    def self.in(_environment)
      # return basic pipeline for now
      new([EmailTransactional::Stages::ActionView.new,
           EmailTransactional::Stages::StoreInMemcached.new])
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
