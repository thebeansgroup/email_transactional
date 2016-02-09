module EmailTransactional
  class PipelineBuilder
    def initialize(*stages)
      @stages = stages
      @before = proc {}
      @after  = proc {}
    end

    def before(&block)
      @before = block
      self
    end

    def after(&block)
      @after = block
      self
    end

    def build
      EmailTransactional::Pipeline.new(@before, @stages, @after)
    end
  end
end
