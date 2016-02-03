module EmailTransactional
  class Config
    DEFAULT_ENVIRONMENT = :development

    class << self
      attr_writer :environment

      def environment
        (@environment || DEFAULT_ENVIRONMENT).to_sym
      end

      def helper
        helper = Module.new
        env = environment
        helper.send(:define_method, :environment, Proc.new { env })
        helper
      end
    end
  end
end
