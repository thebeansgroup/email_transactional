module EmailTransactional
  class Globals
    GLOBALS_PATH = '../../../source/globals.yml'.freeze

    class NoSuchGlobal < StandardError; end

    def self.read
      new(YAML.load_file(File.expand_path(GLOBALS_PATH, __FILE__)))
    end

    def self.helper
      globals = read
      helper = Module.new
      helper.send(:define_method, :globals, proc { globals })
      helper
    end

    def initialize(hash)
      @hash = hash
    end

    private

    def method_missing(method)
      @hash[method.to_s] or raise NoSuchGlobal
    end
  end
end
