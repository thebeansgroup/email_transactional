module EmailTransactional
  class PipelineBuilder
    def initialize(*stages)
      @stages = stages
      @before = Proc.new {}
      @after  = Proc.new {}
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
