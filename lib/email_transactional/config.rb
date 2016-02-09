module EmailTransactional
  class Config
    DEFAULT_ENVIRONMENT = :development

    class << self
      attr_writer :environment
      attr_accessor :memcached_server

      def environment
        (@environment || DEFAULT_ENVIRONMENT).to_sym
      end

      def helper
        helper = Module.new
        env = environment
        helper.send(:define_method, :environment, proc { env })
        helper
      end
    end
  end
end
